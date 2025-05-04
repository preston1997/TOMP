package com.ruoyi.tompSys.domain;

import java.math.BigDecimal;
import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 工厂信息对象 factory
 * 
 * @author 高翔
 * @date 2025-04-26
 */
public class Factory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 工厂ID */
    private Long factoryId;

    /** 工厂名 */
    @Excel(name = "工厂名")
    private String factoryName;

    /** 关联用户ID */
    @Excel(name = "关联用户ID")
    private Long userId;

    /** 上衣产能 */
    @Excel(name = "上衣产能")
    private Long capacityTop;

    /** 裤子产能 */
    @Excel(name = "裤子产能")
    private Long capacityPants;

    /** 上衣成本 */
    @Excel(name = "上衣成本")
    private BigDecimal costTop;

    /** 裤子成本 */
    @Excel(name = "裤子成本")
    private BigDecimal costPants;

    /** 上衣良品率 */
    @Excel(name = "上衣良品率")
    private BigDecimal qualityTop;

    /** 裤子良品率 */
    @Excel(name = "裤子良品率")
    private BigDecimal qualityPants;

    /** 工厂状态 */
    @Excel(name = "工厂状态")
    private Boolean isActive;

    /** 工作时间表 */
    @Excel(name = "工作时间表")
    private String workSchedule;

    /** 工厂变更历史信息 */
    private List<FactoryHistory> factoryHistoryList;

    public void setFactoryId(Long factoryId) 
    {
        this.factoryId = factoryId;
    }

    public Long getFactoryId() 
    {
        return factoryId;
    }

    public void setFactoryName(String factoryName) 
    {
        this.factoryName = factoryName;
    }

    public String getFactoryName() 
    {
        return factoryName;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setCapacityTop(Long capacityTop) 
    {
        this.capacityTop = capacityTop;
    }

    public Long getCapacityTop() 
    {
        return capacityTop;
    }

    public void setCapacityPants(Long capacityPants) 
    {
        this.capacityPants = capacityPants;
    }

    public Long getCapacityPants() 
    {
        return capacityPants;
    }

    public void setCostTop(BigDecimal costTop) 
    {
        this.costTop = costTop;
    }

    public BigDecimal getCostTop() 
    {
        return costTop;
    }

    public void setCostPants(BigDecimal costPants) 
    {
        this.costPants = costPants;
    }

    public BigDecimal getCostPants() 
    {
        return costPants;
    }

    public void setQualityTop(BigDecimal qualityTop) 
    {
        this.qualityTop = qualityTop;
    }

    public BigDecimal getQualityTop() 
    {
        return qualityTop;
    }

    public void setQualityPants(BigDecimal qualityPants) 
    {
        this.qualityPants = qualityPants;
    }

    public BigDecimal getQualityPants() 
    {
        return qualityPants;
    }

    public void setIsActive(Boolean isActive) 
    {
        this.isActive = isActive;
    }

    public Boolean getIsActive() 
    {
        return isActive;
    }

    public void setWorkSchedule(String workSchedule) 
    {
        this.workSchedule = workSchedule;
    }

    public String getWorkSchedule() 
    {
        return workSchedule;
    }

    public List<FactoryHistory> getFactoryHistoryList()
    {
        return factoryHistoryList;
    }

    public void setFactoryHistoryList(List<FactoryHistory> factoryHistoryList)
    {
        this.factoryHistoryList = factoryHistoryList;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("factoryId", getFactoryId())
            .append("factoryName", getFactoryName())
            .append("userId", getUserId())
            .append("capacityTop", getCapacityTop())
            .append("capacityPants", getCapacityPants())
            .append("costTop", getCostTop())
            .append("costPants", getCostPants())
            .append("qualityTop", getQualityTop())
            .append("qualityPants", getQualityPants())
            .append("isActive", getIsActive())
            .append("workSchedule", getWorkSchedule())
            .append("factoryHistoryList", getFactoryHistoryList())
            .toString();
    }
}
