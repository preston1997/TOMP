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
import java.util.Map;
import java.util.HashMap;
import com.ruoyi.tompSys.service.ISubOrderService; // 需根据实际包路径调整
import com.ruoyi.tompSys.domain.SubOrder; // 需根据实际包路径调整
import com.ruoyi.tompSys.domain.Factory; 
import com.ruoyi.tompSys.service.IFactoryService; 

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
    @Autowired
    private ISubOrderService subOrderService;
    @Autowired
    private IFactoryService factoryService;

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

    // ... existing code ...

    /**
 * 获取生产计划详情（含甘特图所需数据）
 * @param planId 生产计划ID
 * @return 包含工厂、子订单、每日进度的详细数据
 */
@PreAuthorize("@ss.hasPermi('produce:plan:view')")
@GetMapping("/detail/{planId}")
public AjaxResult getPlanDetail(@PathVariable Long planId) {
    ProductionPlan plan = productionPlanService.selectProductionPlanByPlanId(planId);
    if (plan == null) {
        return AjaxResult.error("生产计划不存在");
    }
    
    SubOrder subOrder = subOrderService.selectSubOrderBySubOrderId(plan.getSubOrderId());
    if (subOrder == null) {
        return AjaxResult.error("关联子订单不存在");
    }
    
    Factory factory = factoryService.selectFactoryByFactoryId(plan.getFactoryId());
    if (factory == null) {
        return AjaxResult.error("关联工厂不存在");
    }
    
    // 组装前端需要的甘特图数据结构
// 导入Map和HashMap类
Map<String, Object> result = new HashMap<>();
    result.put("subOrderId", subOrder.getSubOrderId());
    result.put("customerName", subOrder.getCustomerName());  // 需确保sub_order表有customer_name字段
    result.put("quantity", subOrder.getQuantity());
    result.put("qualityStandard", subOrder.getQualityStandard());
    result.put("factoryId", factory.getFactoryId());
    result.put("factoryName", factory.getFactoryName());  // 需确保factory表有factory_name字段
    result.put("startDate", plan.getStartDate());
    result.put("endDate", plan.getEndDate());
    result.put("dailyProgress", plan.getDailyProgress());  // JSON字符串需反序列化为Map
    
    return AjaxResult.success(result);
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
