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
import com.ruoyi.tompSys.domain.ProductionLog;
import com.ruoyi.tompSys.service.IProductionLogService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 生产日志Controller
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@RestController
@RequestMapping("/produce/log")
public class ProductionLogController extends BaseController
{
    @Autowired
    private IProductionLogService productionLogService;

    /**
     * 查询生产日志列表
     */
    @PreAuthorize("@ss.hasPermi('produce:log:list')")
    @GetMapping("/list")
    public TableDataInfo list(ProductionLog productionLog)
    {
        startPage();
        List<ProductionLog> list = productionLogService.selectProductionLogList(productionLog);
        return getDataTable(list);
    }

    /**
     * 导出生产日志列表
     */
    @PreAuthorize("@ss.hasPermi('produce:log:export')")
    @Log(title = "生产日志", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ProductionLog productionLog)
    {
        List<ProductionLog> list = productionLogService.selectProductionLogList(productionLog);
        ExcelUtil<ProductionLog> util = new ExcelUtil<ProductionLog>(ProductionLog.class);
        util.exportExcel(response, list, "生产日志数据");
    }

    /**
     * 获取生产日志详细信息
     */
    @PreAuthorize("@ss.hasPermi('produce:log:query')")
    @GetMapping(value = "/{logId}")
    public AjaxResult getInfo(@PathVariable("logId") Long logId)
    {
        return success(productionLogService.selectProductionLogByLogId(logId));
    }

    /**
     * 新增生产日志
     */
    @PreAuthorize("@ss.hasPermi('produce:log:add')")
    @Log(title = "生产日志", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ProductionLog productionLog)
    {
        return toAjax(productionLogService.insertProductionLog(productionLog));
    }

    /**
     * 修改生产日志
     */
    @PreAuthorize("@ss.hasPermi('produce:log:edit')")
    @Log(title = "生产日志", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ProductionLog productionLog)
    {
        return toAjax(productionLogService.updateProductionLog(productionLog));
    }

    /**
     * 删除生产日志
     */
    @PreAuthorize("@ss.hasPermi('produce:log:remove')")
    @Log(title = "生产日志", businessType = BusinessType.DELETE)
	@DeleteMapping("/{logIds}")
    public AjaxResult remove(@PathVariable Long[] logIds)
    {
        return toAjax(productionLogService.deleteProductionLogByLogIds(logIds));
    }
}
