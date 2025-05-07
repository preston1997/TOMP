"""
可视化模块
包含甘特图、成本分布图等核心可视化功能
"""

import os
import matplotlib
matplotlib.use('Agg')  # 在导入pyplot之前设置
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime, timedelta
import numpy as np
from models import Factory, SubOrder

class AdvancedVisualizer:
    """高级可视化工具类，用于生成生产调度相关图表"""
    # 设置中文字体（需系统已安装）
    plt.rcParams['font.sans-serif'] = ['SimHei']  # Windows系统黑体
    plt.rcParams['axes.unicode_minus'] = False  # 解决负号显示问题

    @staticmethod
    def plot_gantt(factories, orders, solution):
        """
        生成精确到小时的生产调度甘特图
        参数:
            factories: List[Factory] - 工厂对象列表
            orders: List[Order] - 订单对象列表（需按创建时间排序）
            solution: List[int] - 优化算法输出的工厂分配方案
        生成文件:
            gantt_charts/factory_<id>_corrected.png - 各工厂独立甘特图
            combined_gantt_corrected.png - 综合甘特图
        """
        os.makedirs("gantt_charts", exist_ok=True)

        # 计算真实调度时间轴
        factory_schedules = AdvancedVisualizer._calculate_real_schedules(factories, orders, solution)

        # 生成独立工厂甘特图
        for factory in factories:
            tasks = factory_schedules[factory.id]
            AdvancedVisualizer._plot_single_factory(factory, tasks)

        # 生成综合甘特图
        AdvancedVisualizer._plot_combined_gantt(factories, factory_schedules)

    @staticmethod
    def _calculate_real_schedules(factories, orders, solution):
        """
        计算真实生产调度时间轴（核心方法）
        参数:
            factories: List[Factory] - 工厂列表
            orders: List[Order] - 订单列表
            solution: List[int] - 染色体编码的工厂分配方案
        返回:
            Dict[int, Dict[str, List]] - 工厂调度计划字典
            结构示例:
            {
                1: {
                    'top': [(start_time, end_time, order_id), ...],
                    'pants': [(start_time, end_time, order_id), ...]
                },
                ...
            }
        """
        schedules = {f.id: {'top': [], 'pants': []} for f in factories}

        # 初始化工厂时间线（含初始负载）
        timeline = {
            f.id: {
                'top': {
                    # 将初始负载转换为小时数（负载量/产能*24小时）
                    'current': f.initial_load['top'] / f.capacity['top'] * 24 if f.capacity['top'] > 0 else 0,
                    'tasks': []
                },
                'pants': {
                    'current': f.initial_load['pants'] / f.capacity['pants'] * 24 if f.capacity['pants'] > 0 else 0,
                    'tasks': []
                }
            } for f in factories
        }

        # 按订单创建时间顺序处理（确保调度时序正确）
        for order in sorted(orders, key=lambda o: o.create_time):
            # 获取当前订单在列表中的索引位置
            order_idx = orders.index(order)

            # === 处理上衣子订单 ===
            top_factory_id = solution[2 * order_idx]  # 染色体前半为上衣分配
            top_factory = next(f for f in factories if f.id == top_factory_id)

            # 计算生产时长（数量/产能 * 24小时）
            top_hours = (order.tops.quantity / top_factory.capacity['top']) * 24 if top_factory.capacity['top'] > 0 else 0

            # 计算实际开始时间（订单创建时间 + 当前工厂已排产时间）
            start_time = order.create_time + timedelta(hours=timeline[top_factory_id]['top']['current'])
            end_time = start_time + timedelta(hours=top_hours)

            # 记录调度计划
            schedules[top_factory_id]['top'].append((start_time, end_time, order.id))
            timeline[top_factory_id]['top']['current'] += top_hours

            # === 处理裤子子订单（逻辑相同）===
            pants_factory_id = solution[2 * order_idx + 1]  # 染色体后半为裤子分配
            pants_factory = next(f for f in factories if f.id == pants_factory_id)

            pants_hours = (order.pants.quantity / pants_factory.capacity['pants']) * 24 if pants_factory.capacity['pants'] > 0 else 0

            start_time = order.create_time + timedelta(hours=timeline[pants_factory_id]['pants']['current'])
            end_time = start_time + timedelta(hours=pants_hours)

            schedules[pants_factory_id]['pants'].append((start_time, end_time, order.id))
            timeline[pants_factory_id]['pants']['current'] += pants_hours

        return schedules

    @staticmethod
    def _plot_single_factory(factory, tasks):
        """
        绘制单个工厂的甘特图
        参数:
            factory: Factory - 工厂对象
            tasks: Dict[str, List] - 该工厂的任务计划
        """
        fig = plt.figure(figsize=(14, 6))
        ax = fig.add_subplot(111)

        # 合并上衣和裤子任务并按开始时间排序
        all_tasks = []
        for product_type in ['top', 'pants']:
            for start, end, order_id in tasks[product_type]:
                all_tasks.append((product_type, start, end, order_id))
        all_tasks.sort(key=lambda x: x[1])

        # 绘制每个任务条
        for idx, (ptype, start, end, order_id) in enumerate(all_tasks):
            color = '#1f77b4' if ptype == 'top' else '#ff7f0e'  # 上衣蓝色，裤子橙色
            duration = (end - start).total_seconds() / 3600  # 转换为小时

            # 绘制任务条
            ax.barh(
                y=idx,
                left=start,
                width=duration,
                height=0.7,
                color=color,
                edgecolor='black',
                alpha=0.8,
                label=ptype.capitalize()
            )

            # 添加任务标签
            label = f"订单#{order_id}\n{ptype}\n{duration:.1f}h"
            ax.text(
                start + timedelta(hours=duration/2),
                idx,
                label,
                ha='center',
                va='center',
                color='white',
                fontsize=8,
                fontweight='bold'
            )

        # 配置图表样式
        ax.set_yticks(range(len(all_tasks)))
        ax.set_yticklabels([f"任务{i+1}" for i in range(len(all_tasks))], fontname='SimHei',fontsize=8)
        ax.set_title(f"工厂 #{factory.id} 生产计划", fontname='SimHei', fontsize=12, pad=15)
        ax.xaxis.set_major_formatter(mdates.DateFormatter("%m-%d %H:%M"))
        plt.xticks(rotation=35)
        plt.grid(axis='x', linestyle=':', alpha=0.5)
        plt.tight_layout()

        # 保存图片
        plt.savefig(f"gantt_charts/factory_{factory.id}_corrected.png", dpi=150, bbox_inches='tight')
        plt.close()

    @staticmethod
    def _plot_combined_gantt(factories, schedules):
        """
        绘制综合甘特图（所有工厂时间轴对比）
        参数:
            factories: List[Factory] - 工厂列表
            schedules: Dict - 调度计划数据
        """
        fig = plt.figure(figsize=(20, len(factories)*3))
        axes = fig.subplots(len(factories), 1, sharex=True)

        # 获取全局时间范围
        all_times = []
        for fid in schedules:
            for ptype in ['top', 'pants']:
                all_times.extend([start for start, _, _ in schedules[fid][ptype]])
                all_times.extend([end for _, end, _ in schedules[fid][ptype]])
        min_time = min(all_times) if all_times else datetime.now()
        max_time = max(all_times) if all_times else datetime.now()

        # 为每个工厂绘制子图
        for idx, factory in enumerate(factories):
            ax = axes[idx] if len(factories) > 1 else axes
            tasks = []
            for ptype in ['top', 'pants']:
                tasks.extend([(ptype, s, e, oid) for s, e, oid in schedules[factory.id][ptype]])
            tasks.sort(key=lambda x: x[1])  # 按开始时间排序

            # 绘制任务条
            for task_idx, (ptype, start, end, oid) in enumerate(tasks):
                color = '#1f77b4' if ptype == 'top' else '#ff7f0e'
                duration = (end - start).total_seconds() / 3600

                ax.barh(
                    y=task_idx,
                    left=start,
                    width=duration,
                    height=0.7,
                    color=color,
                    edgecolor='black',
                    alpha=0.8
                )

                # 添加简略标签
                ax.text(
                    start + timedelta(hours=duration/2),
                    task_idx,
                    f"订单#{oid}",
                    ha='center',
                    va='center',
                    fontname='SimHei',
                    color='white',
                    fontsize=7
                )

            # 配置子图样式
            ax.set_yticks(range(len(tasks)))
            ax.set_yticklabels([f"任务{i+1}" for i in range(len(tasks))], fontname='SimHei', fontsize=8)
            ax.set_title(f"工厂 #{factory.id} 调度计划", fontname='SimHei', fontsize=10)
            ax.xaxis.set_major_formatter(mdates.DateFormatter("%m-%d %H:%M"))
            ax.grid(axis='x', linestyle=':', alpha=0.3)

        # 配置全局样式
        plt.xlim(min_time - timedelta(hours=2), max_time + timedelta(hours=2))
        fig.suptitle("全局生产调度甘特图\n", fontname='SimHei', fontsize=14, y=0.98)
        plt.xlabel("时间轴", fontname='SimHei', labelpad=15)
        plt.xticks(rotation=35)
        plt.subplots_adjust(hspace=0.5, bottom=0.1)
        plt.savefig("combined_gantt_corrected.png", dpi=150, bbox_inches='tight')
        plt.close()

    @staticmethod
    def plot_solution(factories, orders, solution):
        """
        绘制解决方案分析图（成本分布+产能利用率）
        参数:
            factories: List[Factory] - 工厂列表
            orders: List[Order] - 订单列表
            solution: List[int] - 染色体编码方案
        生成文件:
            solution_analysis.png
        """
        fig, axes = plt.subplots(2, 1, figsize=(12, 10))

        # === 成本分布分析 ===
        costs = []
        for factory in factories:
            total_cost = 0
            # 遍历所有订单查找分配给当前工厂的任务
            for order_idx, order in enumerate(orders):
                # 上衣子订单是否分配给当前工厂
                if solution[2*order_idx] == factory.id:
                    total_cost += order.tops.quantity * factory.cost['top']
                # 裤子子订单是否分配给当前工厂
                if solution[2*order_idx+1] == factory.id:
                    total_cost += order.pants.quantity * factory.cost['pants']
            costs.append(total_cost)

        axes[0].bar([f.id for f in factories], costs, color='skyblue')
        axes[0].set_title("各工厂总成本分布", fontname='SimHei', fontsize=12)
        axes[0].set_xlabel("工厂编号")
        axes[0].set_ylabel("总成本（元）")
        for x, y in enumerate(costs):
            axes[0].text(x, y, f'¥{y:.0f}', ha='center', va='bottom')

        # === 产能利用率分析 ===
        utilizations = []
        for factory in factories:
            total_used = 0
            total_capacity = factory.capacity['top'] + factory.capacity['pants']

            # 计算实际使用量
            used_top = sum(order.tops.quantity for order, idx in zip(orders, range(len(orders)))
                         if solution[2*idx] == factory.id)
            used_pants = sum(order.pants.quantity for order, idx in zip(orders, range(len(orders)))
                          if solution[2*idx+1] == factory.id)

            utilization = (used_top + used_pants) / total_capacity * 100 if total_capacity > 0 else 0
            utilizations.append(utilization)

        axes[1].bar([f.id for f in factories], utilizations, color='lightgreen')
        axes[1].set_title("产能利用率分布", fontname='SimHei', fontsize=12)
        axes[1].set_xlabel("工厂编号")
        axes[1].set_ylabel("利用率 (%)")
        axes[1].set_ylim(0, 100)
        for x, y in enumerate(utilizations):
            axes[1].text(x, y, f'{y:.1f}%', ha='center', va='bottom')

        # 保存图表
        plt.tight_layout()
        plt.savefig("solution_analysis.png", dpi=150)
        plt.close()