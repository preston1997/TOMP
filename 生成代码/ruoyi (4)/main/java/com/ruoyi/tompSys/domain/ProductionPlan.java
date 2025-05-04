package com.ruoyi.tompSys.domain;

import java.util.List;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 生产计划对象 production_plan
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public class ProductionPlan extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 计划ID */
    private Long planId;

    /** 关联子订单 */
    @Excel(name = "关联子订单")
    private Long subOrderId;

    /** 生产工厂 */
    @Excel(name = "生产工厂")
    private Long factoryId;

    /** 计划开始日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "计划开始日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date startDate;

    /** 计划完成日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "计划完成日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date endDate;

    /** 实际完成日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "实际完成日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date actualEndDate;

    /** 每日进度 */
    @Excel(name = "每日进度")
    private String dailyProgress;

    /** 当前状态 */
    @Excel(name = "当前状态")
    private String currentStatus;

    /** 生产日志信息 */
    private List<ProductionLog> productionLogList;

    public void setPlanId(Long planId) 
    {
        this.planId = planId;
    }

    public Long getPlanId() 
    {
        return planId;
    }

    public void setSubOrderId(Long subOrderId) 
    {
        this.subOrderId = subOrderId;
    }

    public Long getSubOrderId() 
    {
        return subOrderId;
    }

    public void setFactoryId(Long factoryId) 
    {
        this.factoryId = factoryId;
    }

    public Long getFactoryId() 
    {
        return factoryId;
    }

    public void setStartDate(Date startDate) 
    {
        this.startDate = startDate;
    }

    public Date getStartDate() 
    {
        return startDate;
    }

    public void setEndDate(Date endDate) 
    {
        this.endDate = endDate;
    }

    public Date getEndDate() 
    {
        return endDate;
    }

    public void setActualEndDate(Date actualEndDate) 
    {
        this.actualEndDate = actualEndDate;
    }

    public Date getActualEndDate() 
    {
        return actualEndDate;
    }

    public void setDailyProgress(String dailyProgress) 
    {
        this.dailyProgress = dailyProgress;
    }

    public String getDailyProgress() 
    {
        return dailyProgress;
    }

    public void setCurrentStatus(String currentStatus) 
    {
        this.currentStatus = currentStatus;
    }

    public String getCurrentStatus() 
    {
        return currentStatus;
    }

    public List<ProductionLog> getProductionLogList()
    {
        return productionLogList;
    }

    public void setProductionLogList(List<ProductionLog> productionLogList)
    {
        this.productionLogList = productionLogList;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("planId", getPlanId())
            .append("subOrderId", getSubOrderId())
            .append("factoryId", getFactoryId())
            .append("startDate", getStartDate())
            .append("endDate", getEndDate())
            .append("actualEndDate", getActualEndDate())
            .append("dailyProgress", getDailyProgress())
            .append("currentStatus", getCurrentStatus())
            .append("productionLogList", getProductionLogList())
            .toString();
    }
}
