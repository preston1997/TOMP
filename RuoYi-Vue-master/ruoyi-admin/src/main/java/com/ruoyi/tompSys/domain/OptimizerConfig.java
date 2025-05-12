package com.ruoyi.tompSys.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 参数配置对象 optimizer_config
 * 
 * @author 高翔
 * @date 2025-05-12
 */
public class OptimizerConfig extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 参数名 */
    @Excel(name = "参数名")
    private String description;

    /** 数据类型（如tuple/float/int） */
    @Excel(name = "数据类型", readConverterExp = "如=tuple/float/int")
    private String dataType;

    /** 参数值（JSON格式） */
    @Excel(name = "参数值", readConverterExp = "J=SON格式")
    private String paramValue;

    /** 参数 */
    @Excel(name = "参数")
    private String paramName;

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }

    public void setDataType(String dataType) 
    {
        this.dataType = dataType;
    }

    public String getDataType() 
    {
        return dataType;
    }

    public void setParamValue(String paramValue) 
    {
        this.paramValue = paramValue;
    }

    public String getParamValue() 
    {
        return paramValue;
    }

    public void setParamName(String paramName) 
    {
        this.paramName = paramName;
    }

    public String getParamName() 
    {
        return paramName;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("description", getDescription())
            .append("dataType", getDataType())
            .append("paramValue", getParamValue())
            .append("paramName", getParamName())
            .toString();
    }
}
