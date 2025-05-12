package com.ruoyi.tompSys.mapper;

import java.util.List;
import com.ruoyi.tompSys.domain.OptimizerConfig;

/**
 * 参数配置Mapper接口
 * 
 * @author 高翔
 * @date 2025-05-12
 */
public interface OptimizerConfigMapper 
{
    /**
     * 查询参数配置
     * 
     * @param paramName 参数配置主键
     * @return 参数配置
     */
    public OptimizerConfig selectOptimizerConfigByParamName(String paramName);

    /**
     * 查询参数配置列表
     * 
     * @param optimizerConfig 参数配置
     * @return 参数配置集合
     */
    public List<OptimizerConfig> selectOptimizerConfigList(OptimizerConfig optimizerConfig);

    /**
     * 新增参数配置
     * 
     * @param optimizerConfig 参数配置
     * @return 结果
     */
    public int insertOptimizerConfig(OptimizerConfig optimizerConfig);

    /**
     * 修改参数配置
     * 
     * @param optimizerConfig 参数配置
     * @return 结果
     */
    public int updateOptimizerConfig(OptimizerConfig optimizerConfig);

    /**
     * 删除参数配置
     * 
     * @param paramName 参数配置主键
     * @return 结果
     */
    public int deleteOptimizerConfigByParamName(String paramName);

    /**
     * 批量删除参数配置
     * 
     * @param paramNames 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOptimizerConfigByParamNames(String[] paramNames);
}
