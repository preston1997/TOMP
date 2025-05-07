import logging

from apscheduler.schedulers.background import BackgroundScheduler
from sqlalchemy import text

from database import DatabaseManager
from optimizer import EnhancedOptimizer
from visualizer import AdvancedVisualizer


class Scheduler:
    def __init__(self, db_url):
        self.db_manager = DatabaseManager(db_url)
        self.scheduler = BackgroundScheduler()
        
    def start(self):
        self.scheduler.add_job(self.run_optimization, 'cron', hour=2)  # 每天凌晨2点执行
        self.scheduler.start()
        
    def run_optimization(self):
        logging.info("开始执行优化算法...")
        optimizer = EnhancedOptimizer(self.db_manager)
        solutions = optimizer.optimize()
        if solutions:
            best_solution = min(solutions, key=lambda x: sum(x.fitness.values))
            optimizer.save_production_plan(best_solution)
            
            # 新增可视化生成
            factories = optimizer.factories  # 获取优化器中的工厂数据
            orders = optimizer.orders        # 获取优化器中的订单数据
            AdvancedVisualizer.plot_gantt(factories, orders, best_solution)
            AdvancedVisualizer.plot_solution(factories, orders, best_solution)


            # 记录生产日志
            with self.db_manager.session_scope() as session:
                session.execute(text("""
                    INSERT INTO production_log 
                    (plan_id, log_type, log_time, operator_id)
                    SELECT plan_id, 'START', NOW(), 1 
                    FROM production_plan 
                    WHERE current_status = 'PROCESSING'
                """))