<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="关联生产计划ID" prop="planId">
        <el-input
          v-model="queryParams.planId"
          placeholder="请输入关联生产计划ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="操作人员" prop="operatorId">
        <el-input
          v-model="queryParams.operatorId"
          placeholder="请输入操作人员"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="记录时间">
        <el-date-picker
          v-model="daterangeLogTime"
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
          v-hasPermi="['produce:log:add']"
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
          v-hasPermi="['produce:log:edit']"
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
          v-hasPermi="['produce:log:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['produce:log:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="logList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="日志ID" align="center" prop="logId" />
      <el-table-column label="关联生产计划ID" align="center" prop="planId" />
      <el-table-column label="日志类型" align="center" prop="logType" />
      <el-table-column label="日志详情" align="center" prop="logData" />
      <el-table-column label="操作人员" align="center" prop="operatorId" />
      <el-table-column label="记录时间" align="center" prop="logTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.logTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['produce:log:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['produce:log:remove']"
          >删除</el-button>
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

    <!-- 添加或修改生产日志对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="关联生产计划ID" prop="planId">
          <el-input v-model="form.planId" placeholder="请输入关联生产计划ID" />
        </el-form-item>
        <el-form-item label="操作人员" prop="operatorId">
          <el-input v-model="form.operatorId" placeholder="请输入操作人员" />
        </el-form-item>
        <el-form-item label="记录时间" prop="logTime">
          <el-date-picker clearable
            v-model="form.logTime"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择记录时间">
          </el-date-picker>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listLog, getLog, delLog, addLog, updateLog } from "@/api/produce/log";

export default {
  name: "Log",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 生产日志表格数据
      logList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 记录时间时间范围
      daterangeLogTime: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        planId: null,
        logType: null,
        logData: null,
        operatorId: null,
        logTime: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        planId: [
          { required: true, message: "关联生产计划ID不能为空", trigger: "blur" }
        ],
        logType: [
          { required: true, message: "日志类型不能为空", trigger: "change" }
        ],
        operatorId: [
          { required: true, message: "操作人员不能为空", trigger: "blur" }
        ],
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询生产日志列表 */
    getList() {
      this.loading = true;
      this.queryParams.params = {};
      if (null != this.daterangeLogTime && '' != this.daterangeLogTime) {
        this.queryParams.params["beginLogTime"] = this.daterangeLogTime[0];
        this.queryParams.params["endLogTime"] = this.daterangeLogTime[1];
      }
      listLog(this.queryParams).then(response => {
        this.logList = response.rows;
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
        logId: null,
        planId: null,
        logType: null,
        logData: null,
        operatorId: null,
        logTime: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.daterangeLogTime = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.logId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加生产日志";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const logId = row.logId || this.ids
      getLog(logId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改生产日志";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.logId != null) {
            updateLog(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addLog(this.form).then(response => {
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
      const logIds = row.logId || this.ids;
      this.$modal.confirm('是否确认删除生产日志编号为"' + logIds + '"的数据项？').then(function() {
        return delLog(logIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('produce/log/export', {
        ...this.queryParams
      }, `log_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
