package com.ruoyi.tompSys.service;

import java.util.List;
import com.ruoyi.tompSys.domain.Orders;

/**
 * 订单列表Service接口
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public interface IOrdersService 
{
    /**
     * 查询订单列表
     * 
     * @param orderId 订单列表主键
     * @return 订单列表
     */
    public Orders selectOrdersByOrderId(Long orderId);

    /**
     * 查询订单列表列表
     * 
     * @param orders 订单列表
     * @return 订单列表集合
     */
    public List<Orders> selectOrdersList(Orders orders);

    /**
     * 新增订单列表
     * 
     * @param orders 订单列表
     * @return 结果
     */
    public int insertOrders(Orders orders);

    /**
     * 修改订单列表
     * 
     * @param orders 订单列表
     * @return 结果
     */
    public int updateOrders(Orders orders);

    /**
     * 批量删除订单列表
     * 
     * @param orderIds 需要删除的订单列表主键集合
     * @return 结果
     */
    public int deleteOrdersByOrderIds(Long[] orderIds);

    /**
     * 删除订单列表信息
     * 
     * @param orderId 订单列表主键
     * @return 结果
     */
    public int deleteOrdersByOrderId(Long orderId);
}
