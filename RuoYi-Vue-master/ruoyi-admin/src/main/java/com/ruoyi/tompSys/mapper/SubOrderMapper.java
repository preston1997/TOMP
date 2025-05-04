package com.ruoyi.tompSys.mapper;

import java.util.List;
import com.ruoyi.tompSys.domain.SubOrder;
import com.ruoyi.tompSys.domain.ProductionPlan;

/**
 * 子订单列表Mapper接口
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public interface SubOrderMapper 
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
     * 删除子订单列表
     * 
     * @param subOrderId 子订单列表主键
     * @return 结果
     */
    public int deleteSubOrderBySubOrderId(Long subOrderId);

    /**
     * 批量删除子订单列表
     * 
     * @param subOrderIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSubOrderBySubOrderIds(Long[] subOrderIds);

    /**
     * 批量删除生产计划
     * 
     * @param subOrderIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteProductionPlanBySubOrderIds(Long[] subOrderIds);
    
    /**
     * 批量新增生产计划
     * 
     * @param productionPlanList 生产计划列表
     * @return 结果
     */
    public int batchProductionPlan(List<ProductionPlan> productionPlanList);
    

    /**
     * 通过子订单列表主键删除生产计划信息
     * 
     * @param subOrderId 子订单列表ID
     * @return 结果
     */
    public int deleteProductionPlanBySubOrderId(Long subOrderId);
}
