package com.ruoyi.tompSys.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.tompSys.domain.SubOrder;
import com.ruoyi.tompSys.mapper.OrdersMapper;
import com.ruoyi.tompSys.domain.Orders;
import com.ruoyi.tompSys.service.IOrdersService;
import com.ruoyi.tompSys.mapper.ProductionPlanMapper;
/**
 * 订单列表Service业务层处理
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@Service
public class OrdersServiceImpl implements IOrdersService 
{
    @Autowired
    private OrdersMapper ordersMapper;
    // 新增注入ProductionPlanMapper用于操作生产计划
    @Autowired
    private ProductionPlanMapper productionPlanMapper;

    /**
     * 查询订单列表
     * 
     * @param orderId 订单列表主键
     * @return 订单列表
     */
    @Override
    public Orders selectOrdersByOrderId(Long orderId)
    {
        return ordersMapper.selectOrdersByOrderId(orderId);
    }

    /**
     * 查询订单列表列表
     * 
     * @param orders 订单列表
     * @return 订单列表
     */
    @Override
    public List<Orders> selectOrdersList(Orders orders)
    {
        return ordersMapper.selectOrdersList(orders);
    }

    /**
     * 新增订单列表
     * 
     * @param orders 订单列表
     * @return 结果
     */
    @Transactional
    @Override
    public int insertOrders(Orders orders)
    {
        orders.setCreateTime(DateUtils.getNowDate());
        int rows = ordersMapper.insertOrders(orders);
        insertSubOrder(orders);
        return rows;
    }

    /**
     * 修改订单列表
     * 
     * @param orders 订单列表
     * @return 结果
     */
    @Transactional
    @Override
    public int updateOrders(Orders orders)
    {
        ordersMapper.deleteSubOrderByOrderId(orders.getOrderId());
        insertSubOrder(orders);
        return ordersMapper.updateOrders(orders);
    }

    /**
     * 批量删除订单列表
     * 
     * @param orderIds 需要删除的订单列表主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteOrdersByOrderIds(Long[] orderIds)
    {

        // 3. 原删除子订单逻辑
        ordersMapper.deleteSubOrderByOrderIds(orderIds);
        return ordersMapper.deleteOrdersByOrderIds(orderIds);
    }

    /**
     * 删除订单列表信息
     * 
     * @param orderId 订单列表主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteOrdersByOrderId(Long orderId)
    {
        ordersMapper.deleteProductionPlanByOrderId(orderId);
        ordersMapper.deleteSubOrderByOrderId(orderId);
        return ordersMapper.deleteOrdersByOrderId(orderId);
    }

   


    /**
     * 新增子订单列表信息
     * 
     * @param orders 订单列表对象
     */
    public void insertSubOrder(Orders orders)
    {
        List<SubOrder> subOrderList = orders.getSubOrderList();
        Long orderId = orders.getOrderId();
        if (StringUtils.isNotNull(subOrderList))
        {
            List<SubOrder> list = new ArrayList<SubOrder>();
            for (SubOrder subOrder : subOrderList)
            {
                subOrder.setOrderId(orderId);
                list.add(subOrder);
            }
            if (list.size() > 0)
            {
                ordersMapper.batchSubOrder(list);
            }
        }
    }
    
}