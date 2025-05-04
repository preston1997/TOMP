package com.ruoyi.tompSys.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 生产日志对象 production_log
 * 
 * @author 高翔
 * @date 2025-04-18
 */
public class ProductionLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 日志ID */
    private Long logId;

    /** 关联生产计划ID */
    @Excel(name = "关联生产计划ID")
    private Long planId;

    /** 日志类型 */
    @Excel(name = "日志类型")
    private String logType;

    /** 日志详情 */
    @Excel(name = "日志详情")
    private String logData;

    /** 操作人员 */
    @Excel(name = "操作人员")
    private Long operatorId;

    /** 记录时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "记录时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date logTime;

    public void setLogId(Long logId) 
    {
        this.logId = logId;
    }

    public Long getLogId() 
    {
        return logId;
    }

    public void setPlanId(Long planId) 
    {
        this.planId = planId;
    }

    public Long getPlanId() 
    {
        return planId;
    }

    public void setLogType(String logType) 
    {
        this.logType = logType;
    }

    public String getLogType() 
    {
        return logType;
    }

    public void setLogData(String logData) 
    {
        this.logData = logData;
    }

    public String getLogData() 
    {
        return logData;
    }

    public void setOperatorId(Long operatorId) 
    {
        this.operatorId = operatorId;
    }

    public Long getOperatorId() 
    {
        return operatorId;
    }

    public void setLogTime(Date logTime) 
    {
        this.logTime = logTime;
    }

    public Date getLogTime() 
    {
        return logTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("logId", getLogId())
            .append("planId", getPlanId())
            .append("logType", getLogType())
            .append("logData", getLogData())
            .append("operatorId", getOperatorId())
            .append("logTime", getLogTime())
            .toString();
    }
}
