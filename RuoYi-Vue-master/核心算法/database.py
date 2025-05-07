from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import sessionmaker
from datetime import datetime, timedelta, date
import contextlib
import logging


class DatabaseManager:
    def __init__(self, db_url):
        self.engine = create_engine(db_url)
        self.Session = sessionmaker(bind=self.engine)
        
    @contextlib.contextmanager
    def session_scope(self):
        session = self.Session()
        try:
            yield session
            session.commit()
        except SQLAlchemyError as e:
            session.rollback()
            logging.error(f"数据库操作失败: {str(e)}")
            raise
        finally:
            session.close()

    def load_factories(self):  # 新增关键方法
        with self.session_scope() as session:
            return session.execute(text("""
                SELECT 
                    f.factory_id, 
                    f.capacity_top, 
                    f.capacity_pants,
                    f.cost_top,
                    f.cost_pants,
                    f.quality_top,
                    f.quality_pants,
                    f.initial_load
                FROM factory f
                WHERE f.is_active = 1
            """)).mappings().fetchall()

    def load_orders(self):
        with self.session_scope() as session:
            results = session.execute(text("""
                SELECT 
                    o.order_id, 
                    o.create_time,
                    COALESCE(so_top.sub_order_id, 0) AS top_sub_id,
                    COALESCE(so_top.quantity, 0) AS top_quantity,
                    so_top.deadline AS top_deadline,
                    COALESCE(so_pants.sub_order_id, 0) AS pants_sub_id,
                    COALESCE(so_pants.quantity, 0) AS pants_quantity,
                    so_pants.deadline AS pants_deadline
                FROM orders o
                LEFT JOIN sub_order so_top 
                    ON o.order_id = so_top.order_id 
                    AND so_top.product_id = 1
                LEFT JOIN sub_order so_pants 
                    ON o.order_id = so_pants.order_id 
                    AND so_pants.product_id = 2
                WHERE o.status = 'PENDING'
            """)).mappings().fetchall()

            # 强制转换时间字段，处理空值
            orders_data = []
            for row in results:
                order_info = {
                    "order_id": row['order_id'],
                    "create_time": row['create_time'],
                    "top_sub_id": row['top_sub_id'],
                    "top_quantity": int(row['top_quantity']),
                    "top_deadline": (
                        datetime.combine(row['top_deadline'], datetime.min.time())
                        if isinstance(row['top_deadline'], date)  # 确保处理date类型
                        else datetime.strptime(row['top_deadline'], "%Y-%m-%d")  # 处理字符串
                    ),
                    "pants_sub_id": row['pants_sub_id'],
                    "pants_quantity": int(row['pants_quantity']),
                    "pants_deadline": (
                        datetime.combine(row['pants_deadline'], datetime.min.time())
                        if isinstance(row['pants_deadline'], date)
                        else datetime.strptime(row['pants_deadline'], "%Y-%m-%d")
                    )
                }
                orders_data.append(order_info)
            return orders_data
