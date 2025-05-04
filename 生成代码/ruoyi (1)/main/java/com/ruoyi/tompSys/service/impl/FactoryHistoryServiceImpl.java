package com.ruoyi.tompSys.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.tompSys.mapper.FactoryHistoryMapper;
import com.ruoyi.tompSys.domain.FactoryHistory;
import com.ruoyi.tompSys.service.IFactoryHistoryService;

/**
 * 工厂变更历史Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-04-17
 */
@Service
public class FactoryHistoryServiceImpl implements IFactoryHistoryService 
{
    @Autowired
    private FactoryHistoryMapper factoryHistoryMapper;

    /**
     * 查询工厂变更历史
     * 
     * @param logId 工厂变更历史主键
     * @return 工厂变更历史
     */
    @Override
    public FactoryHistory selectFactoryHistoryByLogId(Long logId)
    {
        return factoryHistoryMapper.selectFactoryHistoryByLogId(logId);
    }

    /**
     * 查询工厂变更历史列表
     * 
     * @param factoryHistory 工厂变更历史
     * @return 工厂变更历史
     */
    @Override
    public List<FactoryHistory> selectFactoryHistoryList(FactoryHistory factoryHistory)
    {
        return factoryHistoryMapper.selectFactoryHistoryList(factoryHistory);
    }

    /**
     * 新增工厂变更历史
     * 
     * @param factoryHistory 工厂变更历史
     * @return 结果
     */
    @Override
    public int insertFactoryHistory(FactoryHistory factoryHistory)
    {
        return factoryHistoryMapper.insertFactoryHistory(factoryHistory);
    }

    /**
     * 修改工厂变更历史
     * 
     * @param factoryHistory 工厂变更历史
     * @return 结果
     */
    @Override
    public int updateFactoryHistory(FactoryHistory factoryHistory)
    {
        return factoryHistoryMapper.updateFactoryHistory(factoryHistory);
    }

    /**
     * 批量删除工厂变更历史
     * 
     * @param logIds 需要删除的工厂变更历史主键
     * @return 结果
     */
    @Override
    public int deleteFactoryHistoryByLogIds(Long[] logIds)
    {
        return factoryHistoryMapper.deleteFactoryHistoryByLogIds(logIds);
    }

    /**
     * 删除工厂变更历史信息
     * 
     * @param logId 工厂变更历史主键
     * @return 结果
     */
    @Override
    public int deleteFactoryHistoryByLogId(Long logId)
    {
        return factoryHistoryMapper.deleteFactoryHistoryByLogId(logId);
    }
}
