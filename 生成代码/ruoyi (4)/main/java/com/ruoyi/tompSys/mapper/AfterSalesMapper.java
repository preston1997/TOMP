package com.ruoyi.tompSys.mapper;

import java.util.List;
import com.ruoyi.tompSys.domain.AfterSales;

/**
 * 售后信息Mapper接口
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public interface AfterSalesMapper 
{
    /**
     * 查询售后信息
     * 
     * @param caseId 售后信息主键
     * @return 售后信息
     */
    public AfterSales selectAfterSalesByCaseId(Long caseId);

    /**
     * 查询售后信息列表
     * 
     * @param afterSales 售后信息
     * @return 售后信息集合
     */
    public List<AfterSales> selectAfterSalesList(AfterSales afterSales);

    /**
     * 新增售后信息
     * 
     * @param afterSales 售后信息
     * @return 结果
     */
    public int insertAfterSales(AfterSales afterSales);

    /**
     * 修改售后信息
     * 
     * @param afterSales 售后信息
     * @return 结果
     */
    public int updateAfterSales(AfterSales afterSales);

    /**
     * 删除售后信息
     * 
     * @param caseId 售后信息主键
     * @return 结果
     */
    public int deleteAfterSalesByCaseId(Long caseId);

    /**
     * 批量删除售后信息
     * 
     * @param caseIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteAfterSalesByCaseIds(Long[] caseIds);
}
