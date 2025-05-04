package com.ruoyi.tompSys.service;

import java.util.List;
import com.ruoyi.tompSys.domain.SubOrder;

/**
 * 子订单列表Service接口
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public interface ISubOrderService 
{
    /**
     * 查询子订单列表
     * 
     * @param subOrderId 子订单列表主键
     * @return 子订单列表
     */
    public SubOrder selectSubOrderBySubOrderId(Long subOrderId);

    /**
     * 查询子订单列表列表
     * 
     * @param subOrder 子订单列表
     * @return 子订单列表集合
     */
    public List<SubOrder> selectSubOrderList(SubOrder subOrder);

    /**
     * 新增子订单列表
     * 
     * @param subOrder 子订单列表
     * @return 结果
     */
    public int insertSubOrder(SubOrder subOrder);

    /**
     * 修改子订单列表
     * 
     * @param subOrder 子订单列表
     * @return 结果
     */
    public int updateSubOrder(SubOrder subOrder);

    /**
     * 批量删除子订单列表
     * 
     * @param subOrderIds 需要删除的子订单列表主键集合
     * @return 结果
     */
    public int deleteSubOrderBySubOrderIds(Long[] subOrderIds);

    /**
     * 删除子订单列表信息
     * 
     * @param subOrderId 子订单列表主键
     * @return 结果
     */
    public int deleteSubOrderBySubOrderId(Long subOrderId);
}
