package com.ruoyi.tompSys.domain;

import java.math.BigDecimal;
import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 订单列表对象 orders
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public class Orders extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 订单ID */
    private Long orderId;

    /** 客户ID */
    @Excel(name = "客户ID")
    private Long customerId;

    /** 订单状态 */
    @Excel(name = "订单状态")
    private String status;

    /** 取消原因 */
    @Excel(name = "取消原因")
    private String cancelReason;

    /** 订单总金额 */
    @Excel(name = "订单总金额")
    private BigDecimal totalAmount;

    /** 子订单列表信息 */
    private List<SubOrder> subOrderList;

    public void setOrderId(Long orderId) 
    {
        this.orderId = orderId;
    }

    public Long getOrderId() 
    {
        return orderId;
    }

    public void setCustomerId(Long customerId) 
    {
        this.customerId = customerId;
    }

    public Long getCustomerId() 
    {
        return customerId;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setCancelReason(String cancelReason) 
    {
        this.cancelReason = cancelReason;
    }

    public String getCancelReason() 
    {
        return cancelReason;
    }

    public void setTotalAmount(BigDecimal totalAmount) 
    {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getTotalAmount() 
    {
        return totalAmount;
    }

    public List<SubOrder> getSubOrderList()
    {
        return subOrderList;
    }

    public void setSubOrderList(List<SubOrder> subOrderList)
    {
        this.subOrderList = subOrderList;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("orderId", getOrderId())
            .append("customerId", getCustomerId())
            .append("createTime", getCreateTime())
            .append("status", getStatus())
            .append("cancelReason", getCancelReason())
            .append("totalAmount", getTotalAmount())
            .append("subOrderList", getSubOrderList())
            .toString();
    }
}
