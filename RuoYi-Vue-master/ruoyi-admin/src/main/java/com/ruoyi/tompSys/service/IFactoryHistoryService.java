package com.ruoyi.tompSys.service;

import java.util.List;
import com.ruoyi.tompSys.domain.FactoryHistory;

/**
 * 工厂变更历史Service接口
 * 
 * @author ruoyi
 * @date 2025-04-18
 */
public interface IFactoryHistoryService 
{
    /**
     * 查询工厂变更历史
     * 
     * @param logId 工厂变更历史主键
     * @return 工厂变更历史
     */
    public FactoryHistory selectFactoryHistoryByLogId(Long logId);

    /**
     * 查询工厂变更历史列表
     * 
     * @param factoryHistory 工厂变更历史
     * @return 工厂变更历史集合
     */
    public List<FactoryHistory> selectFactoryHistoryList(FactoryHistory factoryHistory);

    /**
     * 新增工厂变更历史
     * 
     * @param factoryHistory 工厂变更历史
     * @return 结果
     */
    public int insertFactoryHistory(FactoryHistory factoryHistory);

    /**
     * 修改工厂变更历史
     * 
     * @param factoryHistory 工厂变更历史
     * @return 结果
     */
    public int updateFactoryHistory(FactoryHistory factoryHistory);

    /**
     * 批量删除工厂变更历史
     * 
     * @param logIds 需要删除的工厂变更历史主键集合
     * @return 结果
     */
    public int deleteFactoryHistoryByLogIds(Long[] logIds);

    /**
     * 删除工厂变更历史信息
     * 
     * @param logId 工厂变更历史主键
     * @return 结果
     */
    public int deleteFactoryHistoryByLogId(Long logId);
}
