package com.ruoyi.tompSys.mapper;

import java.util.List;
import com.ruoyi.tompSys.domain.DeliveryAddress;

/**
 * 收货地址Mapper接口
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public interface DeliveryAddressMapper 
{
    /**
     * 查询收货地址
     * 
     * @param addressId 收货地址主键
     * @return 收货地址
     */
    public DeliveryAddress selectDeliveryAddressByAddressId(Long addressId);

    /**
     * 查询收货地址列表
     * 
     * @param deliveryAddress 收货地址
     * @return 收货地址集合
     */
    public List<DeliveryAddress> selectDeliveryAddressList(DeliveryAddress deliveryAddress);

    /**
     * 新增收货地址
     * 
     * @param deliveryAddress 收货地址
     * @return 结果
     */
    public int insertDeliveryAddress(DeliveryAddress deliveryAddress);

    /**
     * 修改收货地址
     * 
     * @param deliveryAddress 收货地址
     * @return 结果
     */
    public int updateDeliveryAddress(DeliveryAddress deliveryAddress);

    /**
     * 删除收货地址
     * 
     * @param addressId 收货地址主键
     * @return 结果
     */
    public int deleteDeliveryAddressByAddressId(Long addressId);

    /**
     * 批量删除收货地址
     * 
     * @param addressIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDeliveryAddressByAddressIds(Long[] addressIds);
}
