package com.ruoyi.tompSys.mapper;

import java.util.List;
import com.ruoyi.tompSys.domain.ProductionPlan;
import com.ruoyi.tompSys.domain.ProductionLog;

/**
 * 生产计划Mapper接口
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public interface ProductionPlanMapper 
{
    /**
     * 查询生产计划
     * 
     * @param planId 生产计划主键
     * @return 生产计划
     */
    public ProductionPlan selectProductionPlanByPlanId(Long planId);

    /**
     * 查询生产计划列表
     * 
     * @param productionPlan 生产计划
     * @return 生产计划集合
     */
    public List<ProductionPlan> selectProductionPlanList(ProductionPlan productionPlan);

    /**
     * 新增生产计划
     * 
     * @param productionPlan 生产计划
     * @return 结果
     */
    public int insertProductionPlan(ProductionPlan productionPlan);

    /**
     * 修改生产计划
     * 
     * @param productionPlan 生产计划
     * @return 结果
     */
    public int updateProductionPlan(ProductionPlan productionPlan);

    /**
     * 删除生产计划
     * 
     * @param planId 生产计划主键
     * @return 结果
     */
    public int deleteProductionPlanByPlanId(Long planId);

    /**
     * 批量删除生产计划
     * 
     * @param planIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteProductionPlanByPlanIds(Long[] planIds);

    /**
     * 批量删除生产日志
     * 
     * @param planIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteProductionLogByPlanIds(Long[] planIds);
    
    /**
     * 批量新增生产日志
     * 
     * @param productionLogList 生产日志列表
     * @return 结果
     */
    public int batchProductionLog(List<ProductionLog> productionLogList);
    

    /**
     * 通过生产计划主键删除生产日志信息
     * 
     * @param planId 生产计划ID
     * @return 结果
     */
    public int deleteProductionLogByPlanId(Long planId);

    /**
     * 根据子订单ID查询关联的生产计划ID
     * @param subOrderIds 子订单ID数组
     * @return 生产计划ID列表
     */
    public List<Long> selectPlanIdsBySubOrderIds(Long[] subOrderIds);

    /**
     * 根据子订单ID批量删除生产计划
     * @param subOrderIds 子订单ID数组
     * @return 影响行数
     */
    int deleteProductionPlanBySubOrderIds(Long[] subOrderIds);

    // 在接口中新增
    public List<Long> selectSubOrderIdsByPlanIds(Long[] planIds);
}
