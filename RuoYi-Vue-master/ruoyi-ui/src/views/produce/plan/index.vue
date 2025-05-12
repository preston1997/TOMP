<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="关联子订单" prop="subOrderId">
        <el-input
          v-model="queryParams.subOrderId"
          placeholder="请输入关联子订单"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="生产工厂" prop="factoryId">
        <el-input
          v-model="queryParams.factoryId"
          placeholder="请输入生产工厂"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="计划开始日期">
        <el-date-picker
          v-model="daterangeStartDate"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="计划完成日期">
        <el-date-picker
          v-model="daterangeEndDate"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="实际完成日期">
        <el-date-picker
          v-model="daterangeActualEndDate"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['produce:plan:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['produce:plan:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['produce:plan:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['produce:plan:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="planList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="计划ID" align="center" prop="planId" />
      <el-table-column label="关联子订单" align="center" prop="subOrderId" />
      <el-table-column label="生产工厂" align="center">
        <template slot-scope="scope">
          <span>{{ getFactoryName(scope.row.factoryId) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="计划开始日期" align="center" prop="startDate" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.startDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="计划完成日期" align="center" prop="endDate" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.endDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="实际完成日期" align="center" prop="actualEndDate" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.actualEndDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="计划进度" align="center" prop="dailyProgress" />
      <el-table-column label="当前状态" align="center" prop="currentStatus" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['produce:plan:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['produce:plan:remove']"
          >删除</el-button>
          <el-button
        size="mini"
        type="text"
        icon="el-icon-picture"
        @click="handleGanttChart(scope.row.planId)"
        v-hasPermi="['produce:plan:view']"
      >查看甘特图</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 甘特图弹窗 -->
  <el-dialog
    title="生产甘特图"
    :visible.sync="ganttDialogVisible"
    width="90%"
    append-to-body
    @close="handleGanttDialogClose"
  >
    <div class="gantt-container">
      <div ref="ganttChart" style="width: 100%; height: 600px"></div>
    </div>
  </el-dialog>

    <!-- 添加或修改生产计划对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="关联子订单" prop="subOrderId">
          <el-input v-model="form.subOrderId" placeholder="请输入关联子订单" />
        </el-form-item>
        <el-form-item label="生产工厂" prop="factoryId">
          <el-input v-model="form.factoryId" placeholder="请输入生产工厂" />
        </el-form-item>
        <el-form-item label="计划开始日期" prop="startDate">
          <el-date-picker clearable
            v-model="form.startDate"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择计划开始日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="计划完成日期" prop="endDate">
          <el-date-picker clearable
            v-model="form.endDate"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择计划完成日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="实际完成日期" prop="actualEndDate">
          <el-date-picker clearable
            v-model="form.actualEndDate"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择实际完成日期">
          </el-date-picker>
        </el-form-item>
        <el-divider content-position="center">生产日志信息</el-divider>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddProductionLog">添加</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteProductionLog">删除</el-button>
          </el-col>
        </el-row>
        <el-table :data="productionLogList" :row-class-name="rowProductionLogIndex" @selection-change="handleProductionLogSelectionChange" ref="productionLog">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="序号" align="center" prop="index" width="50"/>
          <el-table-column label="日志类型" prop="logType" width="150">
            <template slot-scope="scope">
              <el-select v-model="scope.row.logType" placeholder="请选择日志类型">
                <el-option label="请选择字典生成" value="" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="操作人员" prop="operatorId" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.operatorId" placeholder="请输入操作人员" />
            </template>
          </el-table-column>
          <el-table-column label="记录时间" prop="logTime" width="240">
            <template slot-scope="scope">
              <el-date-picker clearable v-model="scope.row.logTime" type="date" value-format="yyyy-MM-dd" placeholder="请选择记录时间" />
            </template>
          </el-table-column>
        </el-table>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPlan, getPlan, delPlan, addPlan, updatePlan } from "@/api/produce/plan";
import { listFactorys, getFactorys, delFactorys, addFactorys, updateFactorys } from "@/api/factory/factorys";
import { getPlanDetail } from '@/api/produce/plan' // 新增：导入 API 函数
import * as echarts from 'echarts';  // 新增：导入 ECharts 库
import { parseTime } from "@/utils";


export default {
  name: "Plan",
  data() {
    return {
      factoryOptions: [],  // 新增：存储工厂ID-名称映射（格式示例：[{id: 1, name: '工厂A'}, ...]）
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 子表选中数据
      checkedProductionLog: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 生产计划表格数据
      planList: [],
      // 生产日志表格数据
      productionLogList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 记录时间时间范围
      daterangeStartDate: [],
      // 记录时间时间范围
      daterangeEndDate: [],
      // 记录时间时间范围
      daterangeActualEndDate: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        subOrderId: null,
        factoryId: null,
        startDate: null,
        endDate: null,
        actualEndDate: null,
        dailyProgress: null,
        currentStatus: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        subOrderId: [
          { required: true, message: "关联子订单不能为空", trigger: "blur" }
        ],
        factoryId: [
          { required: true, message: "生产工厂不能为空", trigger: "blur" }
        ],
        startDate: [
          { required: true, message: "计划开始日期不能为空", trigger: "blur" }
        ],
        endDate: [
          { required: true, message: "计划完成日期不能为空", trigger: "blur" }
        ],
      },
      ganttDialogVisible: false,  // 甘特图弹窗显示状态
      currentPlanId: null,        // 当前选中的计划ID
      ganttChart: null            // ECharts实例（用于销毁）
    };
  },
  created() {
    this.getList();
    this.getFactoryList();
  },
  methods: {
    // 新增：获取工厂列表接口（需根据实际后端API调整）
    async getFactoryList() {
      const params = {
        pageNum: 1,
        pageSize: 1000, // 假设一次性获取所有工厂
      };
      const res = await listFactorys(params);
      this.factoryOptions = res.rows;
    },

    // 新增：根据工厂ID获取名称
    getFactoryName(factoryId) {
      const factory = this.factoryOptions.find(item => item.factoryId === factoryId);
      return factory ? factory.factoryName : '未知工厂';
    },
    /** 查询生产计划列表 */
    getList() {
      this.loading = true;
      this.queryParams.params = {};
      if (null != this.daterangeStartDate && '' != this.daterangeStartDate) {
        this.queryParams.params["beginStartDate"] = this.daterangeStartDate[0];
        this.queryParams.params["endStartDate"] = this.daterangeStartDate[1];
      }
      if (null != this.daterangeEndDate && '' != this.daterangeEndDate) {
        this.queryParams.params["beginEndDate"] = this.daterangeEndDate[0];
        this.queryParams.params["endEndDate"] = this.daterangeEndDate[1];
      }
      if (null != this.daterangeActualEndDate && '' != this.daterangeActualEndDate) {
        this.queryParams.params["beginActualEndDate"] = this.daterangeActualEndDate[0];
        this.queryParams.params["endActualEndDate"] = this.daterangeActualEndDate[1];
      }
      listPlan(this.queryParams).then(response => {
        this.planList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        planId: null,
        subOrderId: null,
        factoryId: null,
        startDate: null,
        endDate: null,
        actualEndDate: null,
        dailyProgress: null,
        currentStatus: null
      };
      this.productionLogList = [];
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.daterangeStartDate = [];
      this.daterangeEndDate = [];
      this.daterangeActualEndDate = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.planId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加生产计划";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const planId = row.planId || this.ids
      getPlan(planId).then(response => {
        this.form = response.data;
        this.productionLogList = response.data.productionLogList;
        this.open = true;
        this.title = "修改生产计划";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.productionLogList = this.productionLogList;
          if (this.form.planId != null) {
            updatePlan(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addPlan(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const planIds = row.planId || this.ids;
      this.$modal.confirm('是否确认删除生产计划编号为"' + planIds + '"的数据项？').then(function() {
        return delPlan(planIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
	/** 生产日志序号 */
    rowProductionLogIndex({ row, rowIndex }) {
      row.index = rowIndex + 1;
    },
    /** 生产日志添加按钮操作 */
    handleAddProductionLog() {
      let obj = {};
      obj.logType = "";
      obj.logData = "";
      obj.operatorId = "";
      obj.logTime = "";
      this.productionLogList.push(obj);
    },
    /** 生产日志删除按钮操作 */
    handleDeleteProductionLog() {
      if (this.checkedProductionLog.length == 0) {
        this.$modal.msgError("请先选择要删除的生产日志数据");
      } else {
        const productionLogList = this.productionLogList;
        const checkedProductionLog = this.checkedProductionLog;
        this.productionLogList = productionLogList.filter(function(item) {
          return checkedProductionLog.indexOf(item.index) == -1
        });
      }
    },
    /** 复选框选中数据 */
    handleProductionLogSelectionChange(selection) {
      this.checkedProductionLog = selection.map(item => item.index)
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('produce/plan/export', {
        ...this.queryParams
      }, `plan_${new Date().getTime()}.xlsx`)
    },
     /** 查看甘特图（弹窗形式） */
     handleGanttChart(planId) {
      this.currentPlanId = planId;
      this.ganttDialogVisible = true;
      this.loadGanttData();  // 加载甘特图数据
    },

    /** 加载甘特图数据 */
    async loadGanttData() {
      if (!this.currentPlanId) return;
      try {
        const response = await getPlanDetail(this.currentPlanId);
        // 关键修复：确保 planData 是数组（若后端返回单对象，用数组包裹）
        const planData = Array.isArray(response.data) ? response.data : [response.data];
        this.renderGanttChart(planData);
      } catch (error) {
        console.error("甘特图数据加载失败:", error);
      }
    },

    /** 渲染甘特图（优化版） */
renderGanttChart(planData) {
  if (this.ganttChart) {
    this.ganttChart.dispose();
  }
  this.ganttChart = echarts.init(this.$refs.ganttChart);
  
  // 数据处理
  const plan = planData[0]; // 假设单条计划数据
  const dailyProgress = JSON.parse(plan.dailyProgress);
  const dates = Object.keys(dailyProgress).sort();
  const progressValues = dates.map(date => dailyProgress[date]);
  
  // 生成累积进度数据
  let cumulative = 0;
  const cumulativeProgress = progressValues.map(value => {
    cumulative += value;
    return cumulative;
  });

  const option = {
    tooltip: {
      trigger: 'axis',
      formatter: (params) => {
        const date = params[0].axisValue;
        const planned = params[0].data;
        const actual = params[1] ? params[1].data : 0;
        return `
          <strong>${date}</strong><br/>
          计划生产量: ${planned}件<br/>
          实际完成: ${actual}件
        `;
      }
    },
    xAxis: {
      type: 'time',
      splitLine: { show: false },
      axisLabel: { 
        formatter: '{yyyy}-{MM}-{dd}',
      }
    },
    yAxis: [{
      type: 'value',
      name: '生产量（件）',
      position: 'left'
    }],
    series: [
      // 计划时间段背景
      {
        type: 'bar',
        name: '计划周期',
        data: [[plan.startDate, plan.endDate, plan.quantity]],
        yAxisIndex: 0,
        itemStyle: {
          color: 'rgba(200, 200, 200, 0.3)'
        },
        barCategoryGap: '0%',
        barWidth: 30
      },
      // 每日实际进度
      {
        type: 'bar',
        name: '每日完成',
        data: dates.map(date => [date, dailyProgress[date]]),
        itemStyle: {
          color: '#36a3f7'
        },
        barWidth: 20
      },
      // 累积进度线
      {
        type: 'line',
        name: '累积进度',
        data: dates.map((date, i) => [date, cumulativeProgress[i]]),
        symbol: 'none',
        lineStyle: {
          color: '#ff6b6b',
          width: 2
        }
      }
    ],
    dataZoom: [{
      type: 'inside',
      xAxisIndex: 0,
      start: 0,
      end: 100
    }]
  };

  this.ganttChart.setOption(option);
},

    /** 关闭甘特图弹窗时销毁图表 */
    handleGanttDialogClose() {
      if (this.ganttChart) {
        this.ganttChart.dispose();
        this.ganttChart = null;
      }
    }
  }
};
</script>