package com.ruoyi.tompSys.service;

import java.util.List;
import com.ruoyi.tompSys.domain.Factory;

/**
 * 工厂信息Service接口
 * 
 * @author 高翔
 * @date 2025-04-26
 */
public interface IFactoryService 
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
     * 批量删除工厂信息
     * 
     * @param factoryIds 需要删除的工厂信息主键集合
     * @return 结果
     */
    public int deleteFactoryByFactoryIds(Long[] factoryIds);

    /**
     * 删除工厂信息信息
     * 
     * @param factoryId 工厂信息主键
     * @return 结果
     */
    public int deleteFactoryByFactoryId(Long factoryId);
}
