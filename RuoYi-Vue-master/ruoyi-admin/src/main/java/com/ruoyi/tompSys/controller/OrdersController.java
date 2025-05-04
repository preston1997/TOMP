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
import com.ruoyi.tompSys.domain.Orders;
import com.ruoyi.tompSys.service.IOrdersService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 订单列表Controller
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@RestController
@RequestMapping("/order/orders")
public class OrdersController extends BaseController
{
    @Autowired
    private IOrdersService ordersService;

    /**
     * 查询订单列表列表
     */
    @PreAuthorize("@ss.hasPermi('order:orders:list')")
    @GetMapping("/list")
    public TableDataInfo list(Orders orders)
    {
        startPage();
        List<Orders> list = ordersService.selectOrdersList(orders);
        return getDataTable(list);
    }

    /**
     * 导出订单列表列表
     */
    @PreAuthorize("@ss.hasPermi('order:orders:export')")
    @Log(title = "订单列表", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Orders orders)
    {
        List<Orders> list = ordersService.selectOrdersList(orders);
        ExcelUtil<Orders> util = new ExcelUtil<Orders>(Orders.class);
        util.exportExcel(response, list, "订单列表数据");
    }

    /**
     * 获取订单列表详细信息
     */
    @PreAuthorize("@ss.hasPermi('order:orders:query')")
    @GetMapping(value = "/{orderId}")
    public AjaxResult getInfo(@PathVariable("orderId") Long orderId)
    {
        return success(ordersService.selectOrdersByOrderId(orderId));
    }

    /**
     * 新增订单列表
     */
    @PreAuthorize("@ss.hasPermi('order:orders:add')")
    @Log(title = "订单列表", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Orders orders)
    {
        return toAjax(ordersService.insertOrders(orders));
    }

    /**
     * 修改订单列表
     */
    @PreAuthorize("@ss.hasPermi('order:orders:edit')")
    @Log(title = "订单列表", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Orders orders)
    {
        return toAjax(ordersService.updateOrders(orders));
    }

    /**
     * 删除订单列表
     */
    @PreAuthorize("@ss.hasPermi('order:orders:remove')")
    @Log(title = "订单列表", businessType = BusinessType.DELETE)
	@DeleteMapping("/{orderIds}")
    public AjaxResult remove(@PathVariable Long[] orderIds)
    {
        return toAjax(ordersService.deleteOrdersByOrderIds(orderIds));
    }
}
