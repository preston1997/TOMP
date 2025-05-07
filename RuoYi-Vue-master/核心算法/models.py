"""
数据模型定义模块
定义系统核心数据结构：工厂(Factory)、子订单(SubOrder)、订单(Order)
"""

from dataclasses import dataclass
from datetime import datetime

@dataclass
class Factory:
    """工厂实体类"""
    id: int                  # 工厂唯一标识
    capacity: dict           # 生产能力字典 {'top': 上衣日产量, 'pants': 裤子日产量}
    cost: dict               # 生产成本字典 {'top': 上衣单位成本, 'pants': 裤子单位成本}
    quality: dict            # 产品质量字典 {'top': 上衣合格率(0-1), 'pants': 裤子合格率}
    initial_load: dict       # 初始负载字典 {'top': 已占用上衣产能, 'pants': 已占用裤子产能}

@dataclass
class SubOrder:
    """子订单实体类（每个订单包含上衣和裤子两个子订单）"""
    product_type: str        # 产品类型 'top'/'pants'
    quantity: int            # 订单数量
    deadline: datetime       # 交货截止时间
    quality_standard: float  # 最低质量要求(0-1)
    id: int = 0  # 新增ID字段

@dataclass
class Order:
    """完整订单实体类"""
    id: int                  # 订单唯一标识
    create_time: datetime    # 订单创建时间
    tops: SubOrder           # 上衣子订单
    pants: SubOrder          # 裤子子订单