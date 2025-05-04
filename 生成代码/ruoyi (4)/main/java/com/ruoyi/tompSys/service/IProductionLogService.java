package com.ruoyi.tompSys.service;

import java.util.List;
import com.ruoyi.tompSys.domain.ProductionLog;

/**
 * 生产日志Service接口
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public interface IProductionLogService 
{
    /**
     * 查询生产日志
     * 
     * @param logId 生产日志主键
     * @return 生产日志
     */
    public ProductionLog selectProductionLogByLogId(Long logId);

    /**
     * 查询生产日志列表
     * 
     * @param productionLog 生产日志
     * @return 生产日志集合
     */
    public List<ProductionLog> selectProductionLogList(ProductionLog productionLog);

    /**
     * 新增生产日志
     * 
     * @param productionLog 生产日志
     * @return 结果
     */
    public int insertProductionLog(ProductionLog productionLog);

    /**
     * 修改生产日志
     * 
     * @param productionLog 生产日志
     * @return 结果
     */
    public int updateProductionLog(ProductionLog productionLog);

    /**
     * 批量删除生产日志
     * 
     * @param logIds 需要删除的生产日志主键集合
     * @return 结果
     */
    public int deleteProductionLogByLogIds(Long[] logIds);

    /**
     * 删除生产日志信息
     * 
     * @param logId 生产日志主键
     * @return 结果
     */
    public int deleteProductionLogByLogId(Long logId);
}
