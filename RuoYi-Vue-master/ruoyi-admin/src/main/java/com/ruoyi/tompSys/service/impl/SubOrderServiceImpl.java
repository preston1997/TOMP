package com.ruoyi.tompSys.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.tompSys.domain.ProductionPlan;
import com.ruoyi.tompSys.mapper.SubOrderMapper;
import com.ruoyi.tompSys.domain.SubOrder;
import com.ruoyi.tompSys.service.ISubOrderService;

/**
 * 子订单列表Service业务层处理
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@Service
public class SubOrderServiceImpl implements ISubOrderService 
{
    @Autowired
    private SubOrderMapper subOrderMapper;

    /**
     * 查询子订单列表
     * 
     * @param subOrderId 子订单列表主键
     * @return 子订单列表
     */
    @Override
    public SubOrder selectSubOrderBySubOrderId(Long subOrderId)
    {
        return subOrderMapper.selectSubOrderBySubOrderId(subOrderId);
    }

    /**
     * 查询子订单列表列表
     * 
     * @param subOrder 子订单列表
     * @return 子订单列表
     */
    @Override
    public List<SubOrder> selectSubOrderList(SubOrder subOrder)
    {
        return subOrderMapper.selectSubOrderList(subOrder);
    }

    /**
     * 新增子订单列表
     * 
     * @param subOrder 子订单列表
     * @return 结果
     */
    @Transactional
    @Override
    public int insertSubOrder(SubOrder subOrder)
    {
        int rows = subOrderMapper.insertSubOrder(subOrder);
        insertProductionPlan(subOrder);
        return rows;
    }

    /**
     * 修改子订单列表
     * 
     * @param subOrder 子订单列表
     * @return 结果
     */
    @Transactional
    @Override
    public int updateSubOrder(SubOrder subOrder)
    {
        subOrderMapper.deleteProductionPlanBySubOrderId(subOrder.getSubOrderId());
        insertProductionPlan(subOrder);
        return subOrderMapper.updateSubOrder(subOrder);
    }

    /**
     * 批量删除子订单列表
     * 
     * @param subOrderIds 需要删除的子订单列表主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteSubOrderBySubOrderIds(Long[] subOrderIds)
    {
        subOrderMapper.deleteProductionPlanBySubOrderIds(subOrderIds);
        return subOrderMapper.deleteSubOrderBySubOrderIds(subOrderIds);
    }

    /**
     * 删除子订单列表信息
     * 
     * @param subOrderId 子订单列表主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteSubOrderBySubOrderId(Long subOrderId)
    {
        subOrderMapper.deleteProductionPlanBySubOrderId(subOrderId);
        return subOrderMapper.deleteSubOrderBySubOrderId(subOrderId);
    }

    /**
     * 新增生产计划信息
     * 
     * @param subOrder 子订单列表对象
     */
    public void insertProductionPlan(SubOrder subOrder)
    {
        List<ProductionPlan> productionPlanList = subOrder.getProductionPlanList();
        Long subOrderId = subOrder.getSubOrderId();
        if (StringUtils.isNotNull(productionPlanList))
        {
            List<ProductionPlan> list = new ArrayList<ProductionPlan>();
            for (ProductionPlan productionPlan : productionPlanList)
            {
                productionPlan.setSubOrderId(subOrderId);
                list.add(productionPlan);
            }
            if (list.size() > 0)
            {
                subOrderMapper.batchProductionPlan(list);
            }
        }
    }
}
