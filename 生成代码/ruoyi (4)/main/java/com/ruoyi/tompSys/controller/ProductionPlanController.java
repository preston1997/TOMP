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
import com.ruoyi.tompSys.domain.ProductionPlan;
import com.ruoyi.tompSys.service.IProductionPlanService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 生产计划Controller
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@RestController
@RequestMapping("/produce/plan")
public class ProductionPlanController extends BaseController
{
    @Autowired
    private IProductionPlanService productionPlanService;

    /**
     * 查询生产计划列表
     */
    @PreAuthorize("@ss.hasPermi('produce:plan:list')")
    @GetMapping("/list")
    public TableDataInfo list(ProductionPlan productionPlan)
    {
        startPage();
        List<ProductionPlan> list = productionPlanService.selectProductionPlanList(productionPlan);
        return getDataTable(list);
    }

    /**
     * 导出生产计划列表
     */
    @PreAuthorize("@ss.hasPermi('produce:plan:export')")
    @Log(title = "生产计划", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ProductionPlan productionPlan)
    {
        List<ProductionPlan> list = productionPlanService.selectProductionPlanList(productionPlan);
        ExcelUtil<ProductionPlan> util = new ExcelUtil<ProductionPlan>(ProductionPlan.class);
        util.exportExcel(response, list, "生产计划数据");
    }

    /**
     * 获取生产计划详细信息
     */
    @PreAuthorize("@ss.hasPermi('produce:plan:query')")
    @GetMapping(value = "/{planId}")
    public AjaxResult getInfo(@PathVariable("planId") Long planId)
    {
        return success(productionPlanService.selectProductionPlanByPlanId(planId));
    }

    /**
     * 新增生产计划
     */
    @PreAuthorize("@ss.hasPermi('produce:plan:add')")
    @Log(title = "生产计划", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ProductionPlan productionPlan)
    {
        return toAjax(productionPlanService.insertProductionPlan(productionPlan));
    }

    /**
     * 修改生产计划
     */
    @PreAuthorize("@ss.hasPermi('produce:plan:edit')")
    @Log(title = "生产计划", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ProductionPlan productionPlan)
    {
        return toAjax(productionPlanService.updateProductionPlan(productionPlan));
    }

    /**
     * 删除生产计划
     */
    @PreAuthorize("@ss.hasPermi('produce:plan:remove')")
    @Log(title = "生产计划", businessType = BusinessType.DELETE)
	@DeleteMapping("/{planIds}")
    public AjaxResult remove(@PathVariable Long[] planIds)
    {
        return toAjax(productionPlanService.deleteProductionPlanByPlanIds(planIds));
    }
}
