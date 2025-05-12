package com.ruoyi.tompSys.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.tompSys.domain.OptimizerConfig;
import com.ruoyi.tompSys.service.IOptimizerConfigService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 参数配置Controller
 * 
 * @author 高翔
 * @date 2025-05-12
 */
@RestController
@RequestMapping("/config/config")
public class OptimizerConfigController extends BaseController
{
    @Autowired
    private IOptimizerConfigService optimizerConfigService;

    /**
     * 查询参数配置列表
     */
    @PreAuthorize("@ss.hasPermi('config:config:list')")
    @GetMapping("/list")
    public TableDataInfo list(OptimizerConfig optimizerConfig)
    {
        startPage();
        List<OptimizerConfig> list = optimizerConfigService.selectOptimizerConfigList(optimizerConfig);
        return getDataTable(list);
    }

    /**
     * 导出参数配置列表
     */
    @PreAuthorize("@ss.hasPermi('config:config:export')")
    @Log(title = "参数配置", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, OptimizerConfig optimizerConfig)
    {
        List<OptimizerConfig> list = optimizerConfigService.selectOptimizerConfigList(optimizerConfig);
        ExcelUtil<OptimizerConfig> util = new ExcelUtil<OptimizerConfig>(OptimizerConfig.class);
        util.exportExcel(response, list, "参数配置数据");
    }

    /**
     * 获取参数配置详细信息
     */
    @PreAuthorize("@ss.hasPermi('config:config:query')")
    @GetMapping(value = "/{paramName}")
    public AjaxResult getInfo(@PathVariable("paramName") String paramName)
    {
        return success(optimizerConfigService.selectOptimizerConfigByParamName(paramName));
    }

    /**
     * 新增参数配置
     */
    @PreAuthorize("@ss.hasPermi('config:config:add')")
    @Log(title = "参数配置", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody OptimizerConfig optimizerConfig)
    {
        return toAjax(optimizerConfigService.insertOptimizerConfig(optimizerConfig));
    }

    /**
     * 修改参数配置
     */
    @PreAuthorize("@ss.hasPermi('config:config:edit')")
    @Log(title = "参数配置", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody OptimizerConfig optimizerConfig)
    {
        return toAjax(optimizerConfigService.updateOptimizerConfig(optimizerConfig));
    }

    /**
     * 删除参数配置
     */
    @PreAuthorize("@ss.hasPermi('config:config:remove')")
    @Log(title = "参数配置", businessType = BusinessType.DELETE)
	@DeleteMapping("/{paramNames}")
    public AjaxResult remove(@PathVariable String[] paramNames)
    {
        return toAjax(optimizerConfigService.deleteOptimizerConfigByParamNames(paramNames));
    }
}
