package com.ruoyi.tompSys.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.tompSys.mapper.OptimizerConfigMapper;
import com.ruoyi.tompSys.domain.OptimizerConfig;
import com.ruoyi.tompSys.service.IOptimizerConfigService;

/**
 * 参数配置Service业务层处理
 * 
 * @author 高翔
 * @date 2025-05-12
 */
@Service
public class OptimizerConfigServiceImpl implements IOptimizerConfigService 
{
    @Autowired
    private OptimizerConfigMapper optimizerConfigMapper;

    /**
     * 查询参数配置
     * 
     * @param paramName 参数配置主键
     * @return 参数配置
     */
    @Override
    public OptimizerConfig selectOptimizerConfigByParamName(String paramName)
    {
        return optimizerConfigMapper.selectOptimizerConfigByParamName(paramName);
    }

    /**
     * 查询参数配置列表
     * 
     * @param optimizerConfig 参数配置
     * @return 参数配置
     */
    @Override
    public List<OptimizerConfig> selectOptimizerConfigList(OptimizerConfig optimizerConfig)
    {
        return optimizerConfigMapper.selectOptimizerConfigList(optimizerConfig);
    }

    /**
     * 新增参数配置
     * 
     * @param optimizerConfig 参数配置
     * @return 结果
     */
    @Override
    public int insertOptimizerConfig(OptimizerConfig optimizerConfig)
    {
        return optimizerConfigMapper.insertOptimizerConfig(optimizerConfig);
    }

    /**
     * 修改参数配置
     * 
     * @param optimizerConfig 参数配置
     * @return 结果
     */
    @Override
    public int updateOptimizerConfig(OptimizerConfig optimizerConfig)
    {
        return optimizerConfigMapper.updateOptimizerConfig(optimizerConfig);
    }

    /**
     * 批量删除参数配置
     * 
     * @param paramNames 需要删除的参数配置主键
     * @return 结果
     */
    @Override
    public int deleteOptimizerConfigByParamNames(String[] paramNames)
    {
        return optimizerConfigMapper.deleteOptimizerConfigByParamNames(paramNames);
    }

    /**
     * 删除参数配置信息
     * 
     * @param paramName 参数配置主键
     * @return 结果
     */
    @Override
    public int deleteOptimizerConfigByParamName(String paramName)
    {
        return optimizerConfigMapper.deleteOptimizerConfigByParamName(paramName);
    }
}
