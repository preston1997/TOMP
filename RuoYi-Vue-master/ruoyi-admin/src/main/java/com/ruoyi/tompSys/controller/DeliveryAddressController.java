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
import com.ruoyi.tompSys.domain.DeliveryAddress;
import com.ruoyi.tompSys.service.IDeliveryAddressService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 收货地址Controller
 * 
 * @author 高翔
 * @date 2025-04-18
 */
@RestController
@RequestMapping("/user/address")
public class DeliveryAddressController extends BaseController
{
    @Autowired
    private IDeliveryAddressService deliveryAddressService;

    /**
     * 查询收货地址列表
     */
    @PreAuthorize("@ss.hasPermi('user:address:list')")
    @GetMapping("/list")
    public TableDataInfo list(DeliveryAddress deliveryAddress)
    {
        startPage();
        List<DeliveryAddress> list = deliveryAddressService.selectDeliveryAddressList(deliveryAddress);
        return getDataTable(list);
    }

    /**
     * 导出收货地址列表
     */
    @PreAuthorize("@ss.hasPermi('user:address:export')")
    @Log(title = "收货地址", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DeliveryAddress deliveryAddress)
    {
        List<DeliveryAddress> list = deliveryAddressService.selectDeliveryAddressList(deliveryAddress);
        ExcelUtil<DeliveryAddress> util = new ExcelUtil<DeliveryAddress>(DeliveryAddress.class);
        util.exportExcel(response, list, "收货地址数据");
    }

    /**
     * 获取收货地址详细信息
     */
    @PreAuthorize("@ss.hasPermi('user:address:query')")
    @GetMapping(value = "/{addressId}")
    public AjaxResult getInfo(@PathVariable("addressId") Long addressId)
    {
        return success(deliveryAddressService.selectDeliveryAddressByAddressId(addressId));
    }

    /**
     * 新增收货地址
     */
    @PreAuthorize("@ss.hasPermi('user:address:add')")
    @Log(title = "收货地址", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DeliveryAddress deliveryAddress)
    {
        return toAjax(deliveryAddressService.insertDeliveryAddress(deliveryAddress));
    }

    /**
     * 修改收货地址
     */
    @PreAuthorize("@ss.hasPermi('user:address:edit')")
    @Log(title = "收货地址", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DeliveryAddress deliveryAddress)
    {
        return toAjax(deliveryAddressService.updateDeliveryAddress(deliveryAddress));
    }

    /**
     * 删除收货地址
     */
    @PreAuthorize("@ss.hasPermi('user:address:remove')")
    @Log(title = "收货地址", businessType = BusinessType.DELETE)
	@DeleteMapping("/{addressIds}")
    public AjaxResult remove(@PathVariable Long[] addressIds)
    {
        return toAjax(deliveryAddressService.deleteDeliveryAddressByAddressIds(addressIds));
    }
}
