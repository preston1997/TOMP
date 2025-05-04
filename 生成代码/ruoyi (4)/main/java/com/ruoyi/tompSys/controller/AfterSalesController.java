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
import com.ruoyi.tompSys.domain.AfterSales;
import com.ruoyi.tompSys.service.IAfterSalesService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 售后信息Controller
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@RestController
@RequestMapping("/order/afterSales")
public class AfterSalesController extends BaseController
{
    @Autowired
    private IAfterSalesService afterSalesService;

    /**
     * 查询售后信息列表
     */
    @PreAuthorize("@ss.hasPermi('order:afterSales:list')")
    @GetMapping("/list")
    public TableDataInfo list(AfterSales afterSales)
    {
        startPage();
        List<AfterSales> list = afterSalesService.selectAfterSalesList(afterSales);
        return getDataTable(list);
    }

    /**
     * 导出售后信息列表
     */
    @PreAuthorize("@ss.hasPermi('order:afterSales:export')")
    @Log(title = "售后信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AfterSales afterSales)
    {
        List<AfterSales> list = afterSalesService.selectAfterSalesList(afterSales);
        ExcelUtil<AfterSales> util = new ExcelUtil<AfterSales>(AfterSales.class);
        util.exportExcel(response, list, "售后信息数据");
    }

    /**
     * 获取售后信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('order:afterSales:query')")
    @GetMapping(value = "/{caseId}")
    public AjaxResult getInfo(@PathVariable("caseId") Long caseId)
    {
        return success(afterSalesService.selectAfterSalesByCaseId(caseId));
    }

    /**
     * 新增售后信息
     */
    @PreAuthorize("@ss.hasPermi('order:afterSales:add')")
    @Log(title = "售后信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody AfterSales afterSales)
    {
        return toAjax(afterSalesService.insertAfterSales(afterSales));
    }

    /**
     * 修改售后信息
     */
    @PreAuthorize("@ss.hasPermi('order:afterSales:edit')")
    @Log(title = "售后信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody AfterSales afterSales)
    {
        return toAjax(afterSalesService.updateAfterSales(afterSales));
    }

    /**
     * 删除售后信息
     */
    @PreAuthorize("@ss.hasPermi('order:afterSales:remove')")
    @Log(title = "售后信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{caseIds}")
    public AjaxResult remove(@PathVariable Long[] caseIds)
    {
        return toAjax(afterSalesService.deleteAfterSalesByCaseIds(caseIds));
    }
}
