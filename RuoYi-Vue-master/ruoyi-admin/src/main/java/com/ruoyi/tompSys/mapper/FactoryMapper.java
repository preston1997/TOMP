package com.ruoyi.tompSys.mapper;

import java.util.List;
import com.ruoyi.tompSys.domain.Factory;
import com.ruoyi.tompSys.domain.FactoryHistory;

/**
 * 工厂信息Mapper接口
 * 
 * @author 高翔
 * @date 2025-04-26
 */
public interface FactoryMapper 
{
    /**
     * 查询工厂信息
     * 
     * @param factoryId 工厂信息主键
     * @return 工厂信息
     */
    public Factory selectFactoryByFactoryId(Long factoryId);

    /**
     * 查询工厂信息列表
     * 
     * @param factory 工厂信息
     * @return 工厂信息集合
     */
    public List<Factory> selectFactoryList(Factory factory);

    /**
     * 新增工厂信息
     * 
     * @param factory 工厂信息
     * @return 结果
     */
    public int insertFactory(Factory factory);

    /**
     * 修改工厂信息
     * 
     * @param factory 工厂信息
     * @return 结果
     */
    public int updateFactory(Factory factory);

    /**
     * 删除工厂信息
     * 
     * @param factoryId 工厂信息主键
     * @return 结果
     */
    public int deleteFactoryByFactoryId(Long factoryId);

    /**
     * 批量删除工厂信息
     * 
     * @param factoryIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFactoryByFactoryIds(Long[] factoryIds);

    /**
     * 批量删除工厂变更历史
     * 
     * @param factoryIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFactoryHistoryByFactoryIds(Long[] factoryIds);
    
    /**
     * 批量新增工厂变更历史
     * 
     * @param factoryHistoryList 工厂变更历史列表
     * @return 结果
     */
    public int batchFactoryHistory(List<FactoryHistory> factoryHistoryList);
    

    /**
     * 通过工厂信息主键删除工厂变更历史信息
     * 
     * @param factoryId 工厂信息ID
     * @return 结果
     */
    public int deleteFactoryHistoryByFactoryId(Long factoryId);
}
