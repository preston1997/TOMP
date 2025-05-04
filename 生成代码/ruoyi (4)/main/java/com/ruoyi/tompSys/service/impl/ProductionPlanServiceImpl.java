package com.ruoyi.tompSys.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.tompSys.domain.ProductionLog;
import com.ruoyi.tompSys.mapper.ProductionPlanMapper;
import com.ruoyi.tompSys.domain.ProductionPlan;
import com.ruoyi.tompSys.service.IProductionPlanService;

/**
 * 生产计划Service业务层处理
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@Service
public class ProductionPlanServiceImpl implements IProductionPlanService 
{
    @Autowired
    private ProductionPlanMapper productionPlanMapper;

    /**
     * 查询生产计划
     * 
     * @param planId 生产计划主键
     * @return 生产计划
     */
    @Override
    public ProductionPlan selectProductionPlanByPlanId(Long planId)
    {
        return productionPlanMapper.selectProductionPlanByPlanId(planId);
    }

    /**
     * 查询生产计划列表
     * 
     * @param productionPlan 生产计划
     * @return 生产计划
     */
    @Override
    public List<ProductionPlan> selectProductionPlanList(ProductionPlan productionPlan)
    {
        return productionPlanMapper.selectProductionPlanList(productionPlan);
    }

    /**
     * 新增生产计划
     * 
     * @param productionPlan 生产计划
     * @return 结果
     */
    @Transactional
    @Override
    public int insertProductionPlan(ProductionPlan productionPlan)
    {
        int rows = productionPlanMapper.insertProductionPlan(productionPlan);
        insertProductionLog(productionPlan);
        return rows;
    }

    /**
     * 修改生产计划
     * 
     * @param productionPlan 生产计划
     * @return 结果
     */
    @Transactional
    @Override
    public int updateProductionPlan(ProductionPlan productionPlan)
    {
        productionPlanMapper.deleteProductionLogByPlanId(productionPlan.getPlanId());
        insertProductionLog(productionPlan);
        return productionPlanMapper.updateProductionPlan(productionPlan);
    }

    /**
     * 批量删除生产计划
     * 
     * @param planIds 需要删除的生产计划主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteProductionPlanByPlanIds(Long[] planIds)
    {
        productionPlanMapper.deleteProductionLogByPlanIds(planIds);
        return productionPlanMapper.deleteProductionPlanByPlanIds(planIds);
    }

    /**
     * 删除生产计划信息
     * 
     * @param planId 生产计划主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteProductionPlanByPlanId(Long planId)
    {
        productionPlanMapper.deleteProductionLogByPlanId(planId);
        return productionPlanMapper.deleteProductionPlanByPlanId(planId);
    }

    /**
     * 新增生产日志信息
     * 
     * @param productionPlan 生产计划对象
     */
    public void insertProductionLog(ProductionPlan productionPlan)
    {
        List<ProductionLog> productionLogList = productionPlan.getProductionLogList();
        Long planId = productionPlan.getPlanId();
        if (StringUtils.isNotNull(productionLogList))
        {
            List<ProductionLog> list = new ArrayList<ProductionLog>();
            for (ProductionLog productionLog : productionLogList)
            {
                productionLog.setPlanId(planId);
                list.add(productionLog);
            }
            if (list.size() > 0)
            {
                productionPlanMapper.batchProductionLog(list);
            }
        }
    }
}
