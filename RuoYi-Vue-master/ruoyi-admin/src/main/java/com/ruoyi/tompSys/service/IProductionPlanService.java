package com.ruoyi.tompSys.service;

import java.util.List;
import com.ruoyi.tompSys.domain.ProductionPlan;

/**
 * 生产计划Service接口
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public interface IProductionPlanService 
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
     * 批量删除生产计划
     * 
     * @param planIds 需要删除的生产计划主键集合
     * @return 结果
     */
    public int deleteProductionPlanByPlanIds(Long[] planIds);

    /**
     * 删除生产计划信息
     * 
     * @param planId 生产计划主键
     * @return 结果
     */
    public int deleteProductionPlanByPlanId(Long planId);
}
