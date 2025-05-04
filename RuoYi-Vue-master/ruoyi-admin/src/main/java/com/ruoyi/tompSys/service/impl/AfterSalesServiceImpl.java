package com.ruoyi.tompSys.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.tompSys.mapper.AfterSalesMapper;
import com.ruoyi.tompSys.domain.AfterSales;
import com.ruoyi.tompSys.service.IAfterSalesService;

/**
 * 售后信息Service业务层处理
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@Service
public class AfterSalesServiceImpl implements IAfterSalesService 
{
    @Autowired
    private AfterSalesMapper afterSalesMapper;

    /**
     * 查询售后信息
     * 
     * @param caseId 售后信息主键
     * @return 售后信息
     */
    @Override
    public AfterSales selectAfterSalesByCaseId(Long caseId)
    {
        return afterSalesMapper.selectAfterSalesByCaseId(caseId);
    }

    /**
     * 查询售后信息列表
     * 
     * @param afterSales 售后信息
     * @return 售后信息
     */
    @Override
    public List<AfterSales> selectAfterSalesList(AfterSales afterSales)
    {
        return afterSalesMapper.selectAfterSalesList(afterSales);
    }

    /**
     * 新增售后信息
     * 
     * @param afterSales 售后信息
     * @return 结果
     */
    @Override
    public int insertAfterSales(AfterSales afterSales)
    {
        afterSales.setCreateTime(DateUtils.getNowDate());
        return afterSalesMapper.insertAfterSales(afterSales);
    }

    /**
     * 修改售后信息
     * 
     * @param afterSales 售后信息
     * @return 结果
     */
    @Override
    public int updateAfterSales(AfterSales afterSales)
    {
        return afterSalesMapper.updateAfterSales(afterSales);
    }

    /**
     * 批量删除售后信息
     * 
     * @param caseIds 需要删除的售后信息主键
     * @return 结果
     */
    @Override
    public int deleteAfterSalesByCaseIds(Long[] caseIds)
    {
        return afterSalesMapper.deleteAfterSalesByCaseIds(caseIds);
    }

    /**
     * 删除售后信息信息
     * 
     * @param caseId 售后信息主键
     * @return 结果
     */
    @Override
    public int deleteAfterSalesByCaseId(Long caseId)
    {
        return afterSalesMapper.deleteAfterSalesByCaseId(caseId);
    }
}
