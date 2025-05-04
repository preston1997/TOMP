package com.ruoyi.tompSys.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 售后信息对象 after_sales
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public class AfterSales extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long caseId;

    /** 关联子订单 */
    @Excel(name = "关联子订单")
    private Long subOrderId;

    /** 问题类型 */
    @Excel(name = "问题类型")
    private String type;

    /** 问题描述 */
    @Excel(name = "问题描述")
    private String description;

    /** 处理状态 */
    @Excel(name = "处理状态")
    private String status;

    /** 赔偿金额 */
    @Excel(name = "赔偿金额")
    private BigDecimal compensation;

    /** 解决时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "解决时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date resolveTime;

    public void setCaseId(Long caseId) 
    {
        this.caseId = caseId;
    }

    public Long getCaseId() 
    {
        return caseId;
    }

    public void setSubOrderId(Long subOrderId) 
    {
        this.subOrderId = subOrderId;
    }

    public Long getSubOrderId() 
    {
        return subOrderId;
    }

    public void setType(String type) 
    {
        this.type = type;
    }

    public String getType() 
    {
        return type;
    }

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setCompensation(BigDecimal compensation) 
    {
        this.compensation = compensation;
    }

    public BigDecimal getCompensation() 
    {
        return compensation;
    }

    public void setResolveTime(Date resolveTime) 
    {
        this.resolveTime = resolveTime;
    }

    public Date getResolveTime() 
    {
        return resolveTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("caseId", getCaseId())
            .append("subOrderId", getSubOrderId())
            .append("type", getType())
            .append("description", getDescription())
            .append("status", getStatus())
            .append("compensation", getCompensation())
            .append("createTime", getCreateTime())
            .append("resolveTime", getResolveTime())
            .toString();
    }
}
