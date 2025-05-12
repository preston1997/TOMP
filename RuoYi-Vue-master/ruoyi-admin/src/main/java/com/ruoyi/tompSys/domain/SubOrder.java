package com.ruoyi.tompSys.domain;

import java.math.BigDecimal;
import java.util.List;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 子订单列表对象 sub_order
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public class SubOrder extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 子订单ID */
    private Long subOrderId;

    /** 主订单ID */
    @Excel(name = "主订单ID")
    private Long orderId;

    /** 产品类型 */
    @Excel(name = "产品类型")
    private Long productId;

    /** 订购数量 */
    @Excel(name = "订购数量")
    private Long quantity;

    /** 交货期限 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "交货期限", width = 30, dateFormat = "yyyy-MM-dd")
    private Date deadline;

    /** 质量要求 */
    @Excel(name = "质量要求")
    private BigDecimal qualityStandard;

    /** 生产要求文件 */
    @Excel(name = "生产要求文件")
    private String productionFile;

    @Excel(name = "客户姓名")
    private String customerName;

    /** 生产计划信息 */
    private List<ProductionPlan> productionPlanList;

    public void setSubOrderId(Long subOrderId) 
    {
        this.subOrderId = subOrderId;
    }
    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Long getSubOrderId() 
    {
        return subOrderId;
    }

    public void setOrderId(Long orderId) 
    {
        this.orderId = orderId;
    }

    public Long getOrderId() 
    {
        return orderId;
    }

    public void setProductId(Long productId) 
    {
        this.productId = productId;
    }

    public Long getProductId() 
    {
        return productId;
    }

    public void setQuantity(Long quantity) 
    {
        this.quantity = quantity;
    }

    public Long getQuantity() 
    {
        return quantity;
    }

    public void setDeadline(Date deadline) 
    {
        this.deadline = deadline;
    }

    public Date getDeadline() 
    {
        return deadline;
    }

    public void setQualityStandard(BigDecimal qualityStandard) 
    {
        this.qualityStandard = qualityStandard;
    }

    public BigDecimal getQualityStandard() 
    {
        return qualityStandard;
    }

    public void setProductionFile(String productionFile) 
    {
        this.productionFile = productionFile;
    }

    public String getProductionFile() 
    {
        return productionFile;
    }

    public List<ProductionPlan> getProductionPlanList()
    {
        return productionPlanList;
    }

    public void setProductionPlanList(List<ProductionPlan> productionPlanList)
    {
        this.productionPlanList = productionPlanList;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("subOrderId", getSubOrderId())
            .append("orderId", getOrderId())
            .append("customerName", getCustomerName())
            .append("productId", getProductId())
            .append("quantity", getQuantity())
            .append("deadline", getDeadline())
            .append("qualityStandard", getQualityStandard())
            .append("productionFile", getProductionFile())
            .append("productionPlanList", getProductionPlanList())
            .toString();
    }
}
