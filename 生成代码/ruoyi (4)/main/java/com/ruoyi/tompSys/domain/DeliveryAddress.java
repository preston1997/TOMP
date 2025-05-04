package com.ruoyi.tompSys.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 收货地址对象 delivery_address
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public class DeliveryAddress extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 收货地址ID */
    private Long addressId;

    /** 所属用户 */
    @Excel(name = "所属用户")
    private Long userId;

    /** 收件人姓名 */
    @Excel(name = "收件人姓名")
    private String recipient;

    /** 联系电话 */
    @Excel(name = "联系电话")
    private String phone;

    /** 详细地址 */
    @Excel(name = "详细地址")
    private String address;

    /** 默认地址标记 */
    @Excel(name = "默认地址标记")
    private Integer isDefault;

    public void setAddressId(Long addressId) 
    {
        this.addressId = addressId;
    }

    public Long getAddressId() 
    {
        return addressId;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setRecipient(String recipient) 
    {
        this.recipient = recipient;
    }

    public String getRecipient() 
    {
        return recipient;
    }

    public void setPhone(String phone) 
    {
        this.phone = phone;
    }

    public String getPhone() 
    {
        return phone;
    }

    public void setAddress(String address) 
    {
        this.address = address;
    }

    public String getAddress() 
    {
        return address;
    }

    public void setIsDefault(Integer isDefault) 
    {
        this.isDefault = isDefault;
    }

    public Integer getIsDefault() 
    {
        return isDefault;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("addressId", getAddressId())
            .append("userId", getUserId())
            .append("recipient", getRecipient())
            .append("phone", getPhone())
            .append("address", getAddress())
            .append("isDefault", getIsDefault())
            .toString();
    }
}
