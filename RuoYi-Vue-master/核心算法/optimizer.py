"""
优化算法模块
包含基于NSGA-II的多目标遗传算法实现
"""
import logging
import random
import numpy as np
from deap import algorithms, base, creator, tools
from datetime import timedelta, datetime, date
import json
from sqlalchemy import text

from database import DatabaseManager
from models import Factory, Order, SubOrder
from visualizer import AdvancedVisualizer


def _evaluate_wrapper(individual, factories, orders):
    total_cost, total_unqualified, total_delay = 0, 0, 0
    factory_status = {f.id: {'top': {'load': f.initial_load['top'], 'schedule': []},
                             'pants': {'load': f.initial_load['pants'], 'schedule': []}}
                      for f in factories}

    try:
        for idx, order in enumerate(orders):
            # 上衣子订单处理
            top_factory = individual[2 * idx]
            cost, uq, delay = EnhancedOptimizer._process_order_static(
                order.tops, top_factory, factories, order.create_time, factory_status)
            total_cost += cost
            total_unqualified += uq
            total_delay += delay

            # 裤子子订单处理
            pants_factory = individual[2 * idx + 1]
            cost, uq, delay = EnhancedOptimizer._process_order_static(
                order.pants, pants_factory, factories, order.create_time, factory_status)
            total_cost += cost
            total_unqualified += uq
            total_delay += delay

        return (total_cost, total_unqualified, total_delay)
    except Exception as e:
        logging.error(f"评估函数异常: {str(e)}")
        return (float('inf'), float('inf'), float('inf'))  # 返回极大值标记无效解


class EnhancedOptimizer:
    """增强型多目标优化器"""

    def __init__(self, db_manager):
        self.db_manager = db_manager
        factories_data = db_manager.load_factories()
        orders_data = db_manager.load_orders()

        # 转换数据库数据到模型对象
        self.factories = [
            Factory(
                id=row['factory_id'],
                capacity={'top': int(row['capacity_top']), 'pants': int(row['capacity_pants'])},
                cost={'top': float(row['cost_top']), 'pants': float(row['cost_pants'])},  # 转换为float
                quality={'top': float(row['quality_top']), 'pants': float(row['quality_pants'])},
                initial_load={'top': int(row['initial_load']), 'pants': 0}
            ) for row in factories_data
        ]

        self.orders = [
            Order(
                id=row['order_id'],
                create_time=row['create_time'],
                tops=SubOrder(
                    'top',
                    row['top_quantity'],
                    row['top_deadline'],
                    0.9,
                    id=row['top_sub_id']
                ),
                pants=SubOrder(
                    'pants',
                    row['pants_quantity'],
                    row['pants_deadline'],
                    0.9,
                    id=row['pants_sub_id']
                )
            ) for row in orders_data
        ]
        self._init_ga()
        # 校验工厂ID是否存在重复或无效值
        factory_ids = [f.id for f in self.factories]
        if len(factory_ids) != len(set(factory_ids)):
            raise ValueError("工厂ID存在重复")

    def save_production_plan(self, solution):
        with self.db_manager.session_scope() as session:

            # 获取订单ID列表
            order_ids = [order.id for order in self.orders]
            # 空值检查（避免IN ()语法错误）
            if not order_ids:
                logging.warning("无待处理订单，跳过状态更新")
                return
            # 使用列表代替元组，并处理单元素情况
            params = {'order_ids': order_ids}  # 直接传递列表
            # 动态生成IN子句占位符
            in_clause = ",".join([":id_{}".format(i) for i in range(len(order_ids))])
            sql = f"""
                        UPDATE orders 
                        SET status = 'PROCESSING' 
                        WHERE order_id IN ({in_clause}) 
                          AND status = 'PENDING'
                    """
            # 构建参数字典（适配不同长度）
            params = {f"id_{i}": oid for i, oid in enumerate(order_ids)}
            session.execute(text(sql), params)
            # 保存生产计划
            # 新增校验逻辑
            if len(solution) != 2 * len(self.orders):
                raise ValueError(f"解向量长度 {len(solution)} 与订单数量 {len(self.orders)} 不匹配")

            for idx, order in enumerate(self.orders):
                top_factory_id = solution[2 * idx]
                pants_factory_id = solution[2 * idx + 1]

                # 校验工厂ID有效性
                if not any(f.id == top_factory_id for f in self.factories):
                    raise ValueError(f"无效上衣工厂ID: {top_factory_id}")
                if not any(f.id == pants_factory_id for f in self.factories):
                    raise ValueError(f"无效裤子工厂ID: {pants_factory_id}")

            factory_schedules = AdvancedVisualizer._calculate_real_schedules(
                self.factories, self.orders, solution
            )

            for idx, order in enumerate(self.orders):
                # 上衣子订单
                top_factory_id = solution[2 * idx]
                top_factory = next(f for f in self.factories if f.id == top_factory_id)
                top_schedule = next(
                    (task for task in factory_schedules[top_factory_id]['top']
                     if task[2] == order.id), None
                )
                if top_schedule:
                    start_date = top_schedule[0]
                    end_date = top_schedule[1]
                    daily_progress = self._calculate_daily_progress(
                        order.tops.quantity,  # 订单总量
                        start_date,  # 开始时间
                        end_date,  # 结束时间
                        top_factory.capacity['top']  # 工厂日产能
                    )
                else:
                    start_date = datetime.now()
                    end_date = datetime.now() + timedelta(days=1)
                    daily_progress = {}

                session.execute(text("""
                    INSERT INTO production_plan 
                    (sub_order_id, factory_id, start_date, end_date, current_status,daily_progress)
                    VALUES (:sub_order_id, :factory_id, :start_date, :end_date, 'PROCESSING', :daily_progress)
                """), {
                    'sub_order_id': order.tops.id,
                    'factory_id': top_factory_id,
                    'start_date': start_date,
                    'end_date': end_date,
                    'daily_progress': json.dumps(daily_progress, ensure_ascii=False)
                })

                # 裤子子订单同理
                pants_factory_id = solution[2 * idx + 1]
                pants_factory = next(f for f in self.factories if f.id == pants_factory_id)
                pants_schedule = next(
                    (task for task in factory_schedules[pants_factory_id]['pants']
                     if task[2] == order.id), None
                )
                if pants_schedule:
                    start_date = pants_schedule[0]
                    end_date = pants_schedule[1]
                    daily_progress = self._calculate_daily_progress(
                        order.pants.quantity,  # 订单总量
                        start_date,  # 开始时间
                        end_date,  # 结束时间
                        pants_factory.capacity['pants']   # 工厂日产能
                    )
                else:
                    start_date = datetime.now()
                    end_date = datetime.now() + timedelta(days=1)
                    daily_progress = {}

                session.execute(text("""
                    INSERT INTO production_plan 
                    (sub_order_id, factory_id, start_date, end_date, current_status, daily_progress)
                    VALUES (:sub_order_id, :factory_id, :start_date, :end_date, 'PROCESSING', :daily_progress)
                """), {
                    'sub_order_id': order.pants.id,
                    'factory_id': pants_factory_id,
                    'start_date': start_date,
                    'end_date': end_date,
                    'daily_progress': json.dumps(daily_progress, ensure_ascii=False)
                })

    def _calculate_daily_progress(self, total_quantity, start_time, end_time, daily_capacity):
        """
        计算每日预计生产量
        参数:
            total_quantity: 订单总量
            start_time: 生产开始时间（datetime）
            end_time: 生产结束时间（datetime）
            daily_capacity: 工厂日产能（件/天）
        返回:
            dict: 格式为 {"YYYY-MM-DD": 数量}
        """
        daily_progress = {}
        current_time = start_time
        remaining_quantity = total_quantity

        # 按天遍历生产周期
        while current_time < end_time and remaining_quantity > 0:
            # 计算当前日期（按自然日划分）
            current_date = current_time.date()
            next_day = current_date + timedelta(days=1)

            # 计算当日有效生产时间（小时）
            day_start = max(current_time, datetime.combine(current_date, datetime.min.time()))
            day_end = min(end_time, datetime.combine(next_day, datetime.min.time()))
            hours_available = (day_end - day_start).total_seconds() / 3600

            # 计算当日产量（基于小时产能）
            daily_production = min(
                remaining_quantity,
                int(hours_available * (daily_capacity / 24))  # 小时产能 = 日产能 / 24
            )

            # 记录到字典
            daily_progress[str(current_date)] = daily_production
            remaining_quantity -= daily_production
            current_time = day_end  # 移动到下一天

        return daily_progress






    # def __init__(self, factories, orders):
    #     """
    #     初始化优化器
    #     参数：
    #         factories: 工厂列表
    #         orders: 订单列表（已按创建时间排序）
    #     """
    #     self.factories = factories
    #     self.orders = orders
    #     self._init_ga()  # 初始化遗传算法框架

    def _init_ga(self):
        """初始化遗传算法框架"""

        # 创建多目标适应度类型（成本、不合格数、延迟量）
        creator.create("FitnessMulti", base.Fitness, weights=(-0.38, -0.337, -0.283))

        # 创建个体类型（染色体编码为订单分配方案）
        creator.create("Individual", list, fitness=creator.FitnessMulti)

        # 配置遗传算法工具箱
        self.toolbox = base.Toolbox()

        # 定义基因生成方式（随机选择工厂）
        # 修改基因生成方式：随机选择实际工厂ID
        valid_factory_ids = [f.id for f in self.factories]
        self.toolbox.register("attr_factory", lambda: random.choice(valid_factory_ids))

        # 定义个体生成方式（每个订单需要分配上衣和裤子两个子订单）
        self.toolbox.register("individual", tools.initRepeat, creator.Individual,
                              self.toolbox.attr_factory, len(self.orders) * 2)

        # 定义种群生成方式
        self.toolbox.register("population", tools.initRepeat, list, self.toolbox.individual)

        # 配置遗传算子
        self.toolbox.register("mate", tools.cxTwoPoint)  # 两点交叉
        # self.toolbox.register("mutate", tools.mutUniformInt,  # 均匀整数变异
        #                       low=0, up=len(self.factories) - 1, indpb=0.2)
        # 替换原变异算子
        self.toolbox.register("mutate", self._adaptive_mutate)
        
        self.toolbox.register("select", tools.selNSGA2)  # NSGA-II选择算子

        # 注册评估函数
        self.toolbox.register("evaluate", _evaluate_wrapper, 
                             factories=self.factories,
                             orders=self.orders)

    def _adaptive_mutate(self, individual, T=1000):
        """自适应温度变异"""
        valid_factory_ids = [f.id for f in self.factories]  # 获取有效工厂ID列表
        for i in range(len(individual)):
            if random.random() < 0.5 * (T / 1000):
                individual[i] = random.choice(valid_factory_ids)  # 从有效ID中选择
        return (individual,)

    
    
    def _evaluate(self, individual):
        """
        适应度评估函数
        参数：
            individual: 个体染色体（工厂分配方案）
        返回：
            三元组（总成本，总不合格数，总延迟量）
        """

        total_cost = 0  # 总成本
        total_unqualified = 0  # 总不合格数量
        total_delay = 0  # 总延迟量（数量×延迟天数）

        # 初始化工厂状态跟踪器
        factory_status = {
            f.id: {
                'top': {'load': f.initial_load['top'], 'schedule': []},
                'pants': {'load': f.initial_load['pants'], 'schedule': []}
            } for f in self.factories
        }

        # 按订单创建时间顺序处理每个订单
        for idx, order in enumerate(self.orders):
            # 处理上衣子订单 --------------------------------------------------
            top_factory = individual[2 * idx]  # 染色体前半部分为上衣分配
            cost, uq, delay = self._process_order(
                order.tops, top_factory, order.create_time, factory_status
            )
            total_cost += cost
            total_unqualified += uq
            total_delay += delay

            # 处理裤子子订单 --------------------------------------------------
            pants_factory = individual[2 * idx + 1]  # 染色体后半部分为裤子分配
            cost, uq, delay = self._process_order(
                order.pants, pants_factory, order.create_time, factory_status
            )
            total_cost += cost
            total_unqualified += uq
            total_delay += delay

        return (total_cost, total_unqualified, total_delay)

    # 改进说明：
    # 1. 动态惩罚系数 1e4 可根据实际订单规模调整，建议设置为日均产能的10倍
    # 2. 使用绝对值确保惩罚值与产能缺口成正比
    # 3. 统一三个目标的惩罚量纲，避免帕累托前沿扭曲
    # 4. 保留负产能检测逻辑，但用更温和的惩罚替代极端值
    # 该改进可使算法：
    # - 更好区分不同严重程度的违规解
    # - 保持多目标优化的平衡性
    # - 增加搜索空间中的可行解梯度信息
    # - 避免过早收敛到局部最优
    @staticmethod
    def _process_order_static(suborder, factory_id, factories, create_time, factory_status):
        try:
            factory = next(f for f in factories if f.id == factory_id)
        except StopIteration:
            # 处理无效工厂ID的情况
            logging.error(f"无效的工厂ID: {factory_id}，可用工厂列表: {[f.id for f in factories]}")
            return (float('inf'), float('inf'), float('inf'))  # 返回极大值

        # 检查时间类型是否为datetime
        if isinstance(suborder.deadline, date):
            suborder.deadline = datetime.combine(suborder.deadline, datetime.min.time())

        status = factory_status[factory_id][suborder.product_type]
        remaining_capacity = factory.capacity[suborder.product_type] - status['load']

        # 修改判断条件为订单数量超过剩余产能
        if suborder.quantity > remaining_capacity:
            overload = suborder.quantity - remaining_capacity
            penalty = 1e4 * overload
            return (penalty, penalty, penalty)

        # 防止除零错误
        if remaining_capacity == 0:
            return (float('inf'), float('inf'), float('inf'))

        production_days = suborder.quantity / remaining_capacity
        end_time = create_time + timedelta(days=production_days)
        delay_days = max(0, (end_time - suborder.deadline).days)
        quality_gap = max(0, suborder.quality_standard - factory.quality[suborder.product_type])
        unqualified = suborder.quantity * quality_gap

        status['load'] += suborder.quantity
        status['schedule'].append((create_time, end_time))

        return (
            suborder.quantity * factory.cost[suborder.product_type],
            unqualified,
            suborder.quantity * delay_days
        )

    def optimize(self, pop_size=300, ngen=500):
        """
        执行优化过程
        参数：
            pop_size: 种群规模
            ngen: 迭代次数
        返回：
            帕累托前沿解集
        """

        # 初始化进程池
        # 修改多进程初始化逻辑
        pool = None
        try:
            if __name__ != "__main__":  # 确保只在主模块启动进程池
                import multiprocessing
                pool = multiprocessing.Pool(processes=multiprocessing.cpu_count())
                self.toolbox.register("map", pool.map)
            else:
                self.toolbox.register("map", map)

            # 初始化种群
            pop = self.toolbox.population(n=pop_size)

            # 配置帕累托前沿记录
            hof = tools.ParetoFront()

            # 配置统计指标
            stats = tools.Statistics(lambda ind: ind.fitness.values)
            stats.register("avg", np.mean)
            stats.register("min", np.min)

            # 执行进化算法
            algorithms.eaMuPlusLambda(
                pop, self.toolbox,
                mu=pop_size,  # 父代数量
                lambda_=pop_size,  # 子代数量
                cxpb=0.7,  # 交叉概率
                mutpb=0.3,  # 变异概率
                ngen=ngen,  # 迭代次数
                stats=stats,  # 统计对象
                halloffame=hof,  # 最优解保存器
                verbose=True  # 显示进度
            )


            # 对帕累托前沿解执行退火
            for ind in hof.items:
                self._simulated_annealing(ind, T=1000, cooling_rate=0.95)

            return hof.items
        finally:
            # 关闭进程池
            # 仅在创建了进程池时关闭
            if pool:
                pool.close()
                pool.join()




    def _simulated_annealing(self, individual, T=500, cooling_rate=0.95):
        """模拟退火局部优化"""
        T = len(self.orders) * 500  # 基于订单量动态计算
        cooling_rate = 0.85 + 0.1 * random.random()  # 随机降温速率
        current_fitness = self.toolbox.evaluate(individual)
        for _ in range(100):  # 每个温度迭代次数
            # 生成邻域解
            mutant = self.toolbox.clone(individual)
            self.toolbox.mutate(mutant)
            new_fitness = self.toolbox.evaluate(mutant)
            
            # 计算能量差
            delta = (sum(new_fitness) - sum(current_fitness)) / T
            
            # Metropolis准则接受新解
            if delta < 0 or random.random() < np.exp(-delta):
                individual[:] = mutant
                current_fitness = new_fitness
                
            T *= cooling_rate  # 降温
        return individual
