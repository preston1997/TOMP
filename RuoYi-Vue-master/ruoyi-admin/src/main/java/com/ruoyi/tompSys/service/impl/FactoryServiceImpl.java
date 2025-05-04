package com.ruoyi.tompSys.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.tompSys.domain.FactoryHistory;
import com.ruoyi.tompSys.mapper.FactoryMapper;
import com.ruoyi.tompSys.domain.Factory;
import com.ruoyi.tompSys.service.IFactoryService;

/**
 * 工厂信息Service业务层处理
 * 
 * @author 高翔
 * @date 2025-04-26
 */
@Service
public class FactoryServiceImpl implements IFactoryService 
{
    @Autowired
    private FactoryMapper factoryMapper;

    /**
     * 查询工厂信息
     * 
     * @param factoryId 工厂信息主键
     * @return 工厂信息
     */
    @Override
    public Factory selectFactoryByFactoryId(Long factoryId)
    {
        return factoryMapper.selectFactoryByFactoryId(factoryId);
    }

    /**
     * 查询工厂信息列表
     * 
     * @param factory 工厂信息
     * @return 工厂信息
     */
    @Override
    public List<Factory> selectFactoryList(Factory factory)
    {
        return factoryMapper.selectFactoryList(factory);
    }

    /**
     * 新增工厂信息
     * 
     * @param factory 工厂信息
     * @return 结果
     */
    @Transactional
    @Override
    public int insertFactory(Factory factory)
    {
        int rows = factoryMapper.insertFactory(factory);
        insertFactoryHistory(factory);
        return rows;
    }

    /**
     * 修改工厂信息
     * 
     * @param factory 工厂信息
     * @return 结果
     */
    @Transactional
    @Override
    public int updateFactory(Factory factory)
    {
        factoryMapper.deleteFactoryHistoryByFactoryId(factory.getFactoryId());
        insertFactoryHistory(factory);
        return factoryMapper.updateFactory(factory);
    }

    /**
     * 批量删除工厂信息
     * 
     * @param factoryIds 需要删除的工厂信息主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteFactoryByFactoryIds(Long[] factoryIds)
    {
        factoryMapper.deleteFactoryHistoryByFactoryIds(factoryIds);
        return factoryMapper.deleteFactoryByFactoryIds(factoryIds);
    }

    /**
     * 删除工厂信息信息
     * 
     * @param factoryId 工厂信息主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteFactoryByFactoryId(Long factoryId)
    {
        factoryMapper.deleteFactoryHistoryByFactoryId(factoryId);
        return factoryMapper.deleteFactoryByFactoryId(factoryId);
    }

    /**
     * 新增工厂变更历史信息
     * 
     * @param factory 工厂信息对象
     */
    public void insertFactoryHistory(Factory factory)
    {
        List<FactoryHistory> factoryHistoryList = factory.getFactoryHistoryList();
        Long factoryId = factory.getFactoryId();
        if (StringUtils.isNotNull(factoryHistoryList))
        {
            List<FactoryHistory> list = new ArrayList<FactoryHistory>();
            for (FactoryHistory factoryHistory : factoryHistoryList)
            {
                factoryHistory.setFactoryId(factoryId);
                list.add(factoryHistory);
            }
            if (list.size() > 0)
            {
                factoryMapper.batchFactoryHistory(list);
            }
        }
    }
}
