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
import com.ruoyi.tompSys.domain.SubOrder;
import com.ruoyi.tompSys.service.ISubOrderService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 子订单列表Controller
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@RestController
@RequestMapping("/order/subOrder")
public class SubOrderController extends BaseController
{
    @Autowired
    private ISubOrderService subOrderService;

    /**
     * 查询子订单列表列表
     */
    @PreAuthorize("@ss.hasPermi('order:subOrder:list')")
    @GetMapping("/list")
    public TableDataInfo list(SubOrder subOrder)
    {
        startPage();
        List<SubOrder> list = subOrderService.selectSubOrderList(subOrder);
        return getDataTable(list);
    }

    /**
     * 导出子订单列表列表
     */
    @PreAuthorize("@ss.hasPermi('order:subOrder:export')")
    @Log(title = "子订单列表", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SubOrder subOrder)
    {
        List<SubOrder> list = subOrderService.selectSubOrderList(subOrder);
        ExcelUtil<SubOrder> util = new ExcelUtil<SubOrder>(SubOrder.class);
        util.exportExcel(response, list, "子订单列表数据");
    }

    /**
     * 获取子订单列表详细信息
     */
    @PreAuthorize("@ss.hasPermi('order:subOrder:query')")
    @GetMapping(value = "/{subOrderId}")
    public AjaxResult getInfo(@PathVariable("subOrderId") Long subOrderId)
    {
        return success(subOrderService.selectSubOrderBySubOrderId(subOrderId));
    }

    /**
     * 新增子订单列表
     */
    @PreAuthorize("@ss.hasPermi('order:subOrder:add')")
    @Log(title = "子订单列表", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SubOrder subOrder)
    {
        return toAjax(subOrderService.insertSubOrder(subOrder));
    }

    /**
     * 修改子订单列表
     */
    @PreAuthorize("@ss.hasPermi('order:subOrder:edit')")
    @Log(title = "子订单列表", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SubOrder subOrder)
    {
        return toAjax(subOrderService.updateSubOrder(subOrder));
    }

    /**
     * 删除子订单列表
     */
    @PreAuthorize("@ss.hasPermi('order:subOrder:remove')")
    @Log(title = "子订单列表", businessType = BusinessType.DELETE)
	@DeleteMapping("/{subOrderIds}")
    public AjaxResult remove(@PathVariable Long[] subOrderIds)
    {
        return toAjax(subOrderService.deleteSubOrderBySubOrderIds(subOrderIds));
    }
}
