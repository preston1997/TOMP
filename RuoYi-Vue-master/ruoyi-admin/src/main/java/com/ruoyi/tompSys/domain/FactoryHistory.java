package com.ruoyi.tompSys.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 工厂变更历史对象 factory_history
 * 
 * @author 高翔
 * @date 2025-04-26
 */
public class FactoryHistory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 日志ID */
    private Long logId;

    /** 关联工厂 */
    @Excel(name = "关联工厂")
    private Long factoryId;

    /** 变更字段 */
    @Excel(name = "变更字段")
    private String changedField;

    /** 原值 */
    @Excel(name = "原值")
    private String oldValue;

    /** 新值 */
    @Excel(name = "新值")
    private String newValue;

    /** 变更时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "变更时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date changeTime;

    /** 操作人员 */
    @Excel(name = "操作人员")
    private Long operatorId;

    public void setLogId(Long logId) 
    {
        this.logId = logId;
    }

    public Long getLogId() 
    {
        return logId;
    }
    public void setFactoryId(Long factoryId) 
    {
        this.factoryId = factoryId;
    }

    public Long getFactoryId() 
    {
        return factoryId;
    }
    public void setChangedField(String changedField) 
    {
        this.changedField = changedField;
    }

    public String getChangedField() 
    {
        return changedField;
    }
    public void setOldValue(String oldValue) 
    {
        this.oldValue = oldValue;
    }

    public String getOldValue() 
    {
        return oldValue;
    }
    public void setNewValue(String newValue) 
    {
        this.newValue = newValue;
    }

    public String getNewValue() 
    {
        return newValue;
    }
    public void setChangeTime(Date changeTime) 
    {
        this.changeTime = changeTime;
    }

    public Date getChangeTime() 
    {
        return changeTime;
    }
    public void setOperatorId(Long operatorId) 
    {
        this.operatorId = operatorId;
    }

    public Long getOperatorId() 
    {
        return operatorId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("logId", getLogId())
            .append("factoryId", getFactoryId())
            .append("changedField", getChangedField())
            .append("oldValue", getOldValue())
            .append("newValue", getNewValue())
            .append("changeTime", getChangeTime())
            .append("operatorId", getOperatorId())
            .toString();
    }
}
