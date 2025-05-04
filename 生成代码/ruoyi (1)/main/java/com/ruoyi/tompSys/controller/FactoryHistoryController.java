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
import com.ruoyi.tompSys.domain.FactoryHistory;
import com.ruoyi.tompSys.service.IFactoryHistoryService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 工厂变更历史Controller
 * 
 * @author ruoyi
 * @date 2025-04-17
 */
@RestController
@RequestMapping("/factory/factoryHistory")
public class FactoryHistoryController extends BaseController
{
    @Autowired
    private IFactoryHistoryService factoryHistoryService;

    /**
     * 查询工厂变更历史列表
     */
    @PreAuthorize("@ss.hasPermi('factory:factoryHistory:list')")
    @GetMapping("/list")
    public TableDataInfo list(FactoryHistory factoryHistory)
    {
        startPage();
        List<FactoryHistory> list = factoryHistoryService.selectFactoryHistoryList(factoryHistory);
        return getDataTable(list);
    }

    /**
     * 导出工厂变更历史列表
     */
    @PreAuthorize("@ss.hasPermi('factory:factoryHistory:export')")
    @Log(title = "工厂变更历史", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, FactoryHistory factoryHistory)
    {
        List<FactoryHistory> list = factoryHistoryService.selectFactoryHistoryList(factoryHistory);
        ExcelUtil<FactoryHistory> util = new ExcelUtil<FactoryHistory>(FactoryHistory.class);
        util.exportExcel(response, list, "工厂变更历史数据");
    }

    /**
     * 获取工厂变更历史详细信息
     */
    @PreAuthorize("@ss.hasPermi('factory:factoryHistory:query')")
    @GetMapping(value = "/{logId}")
    public AjaxResult getInfo(@PathVariable("logId") Long logId)
    {
        return success(factoryHistoryService.selectFactoryHistoryByLogId(logId));
    }

    /**
     * 新增工厂变更历史
     */
    @PreAuthorize("@ss.hasPermi('factory:factoryHistory:add')")
    @Log(title = "工厂变更历史", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody FactoryHistory factoryHistory)
    {
        return toAjax(factoryHistoryService.insertFactoryHistory(factoryHistory));
    }

    /**
     * 修改工厂变更历史
     */
    @PreAuthorize("@ss.hasPermi('factory:factoryHistory:edit')")
    @Log(title = "工厂变更历史", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody FactoryHistory factoryHistory)
    {
        return toAjax(factoryHistoryService.updateFactoryHistory(factoryHistory));
    }

    /**
     * 删除工厂变更历史
     */
    @PreAuthorize("@ss.hasPermi('factory:factoryHistory:remove')")
    @Log(title = "工厂变更历史", businessType = BusinessType.DELETE)
	@DeleteMapping("/{logIds}")
    public AjaxResult remove(@PathVariable Long[] logIds)
    {
        return toAjax(factoryHistoryService.deleteFactoryHistoryByLogIds(logIds));
    }
}
