package com.ruoyi.tompSys.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.tompSys.mapper.ProductionLogMapper;
import com.ruoyi.tompSys.domain.ProductionLog;
import com.ruoyi.tompSys.service.IProductionLogService;

/**
 * 生产日志Service业务层处理
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@Service
public class ProductionLogServiceImpl implements IProductionLogService 
{
    @Autowired
    private ProductionLogMapper productionLogMapper;

    /**
     * 查询生产日志
     * 
     * @param logId 生产日志主键
     * @return 生产日志
     */
    @Override
    public ProductionLog selectProductionLogByLogId(Long logId)
    {
        return productionLogMapper.selectProductionLogByLogId(logId);
    }

    /**
     * 查询生产日志列表
     * 
     * @param productionLog 生产日志
     * @return 生产日志
     */
    @Override
    public List<ProductionLog> selectProductionLogList(ProductionLog productionLog)
    {
        return productionLogMapper.selectProductionLogList(productionLog);
    }

    /**
     * 新增生产日志
     * 
     * @param productionLog 生产日志
     * @return 结果
     */
    @Override
    public int insertProductionLog(ProductionLog productionLog)
    {
        return productionLogMapper.insertProductionLog(productionLog);
    }

    /**
     * 修改生产日志
     * 
     * @param productionLog 生产日志
     * @return 结果
     */
    @Override
    public int updateProductionLog(ProductionLog productionLog)
    {
        return productionLogMapper.updateProductionLog(productionLog);
    }

    /**
     * 批量删除生产日志
     * 
     * @param logIds 需要删除的生产日志主键
     * @return 结果
     */
    @Override
    public int deleteProductionLogByLogIds(Long[] logIds)
    {
        return productionLogMapper.deleteProductionLogByLogIds(logIds);
    }

    /**
     * 删除生产日志信息
     * 
     * @param logId 生产日志主键
     * @return 结果
     */
    @Override
    public int deleteProductionLogByLogId(Long logId)
    {
        return productionLogMapper.deleteProductionLogByLogId(logId);
    }
}
