<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="关联工厂" prop="factoryId">
        <el-input
          v-model="queryParams.factoryId"
          placeholder="请输入关联工厂"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="变更字段" prop="changedField">
        <el-input
          v-model="queryParams.changedField"
          placeholder="请输入变更字段"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="原值" prop="oldValue">
        <el-input
          v-model="queryParams.oldValue"
          placeholder="请输入原值"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="新值" prop="newValue">
        <el-input
          v-model="queryParams.newValue"
          placeholder="请输入新值"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="变更时间" prop="changeTime">
        <el-date-picker clearable
          v-model="queryParams.changeTime"
          type="date"
          value-format="yyyy-MM-dd"
          placeholder="请选择变更时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="操作人员" prop="operatorId">
        <el-input
          v-model="queryParams.operatorId"
          placeholder="请输入操作人员"
          clearable
          @keyup.enter.native="handleQuery"
        />
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
          v-hasPermi="['factory:factoryHistory:add']"
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
          v-hasPermi="['factory:factoryHistory:edit']"
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
          v-hasPermi="['factory:factoryHistory:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['factory:factoryHistory:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="factoryHistoryList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="日志ID" align="center" prop="logId" />
      <el-table-column label="关联工厂" align="center" prop="factoryId" />
      <el-table-column label="变更字段" align="center" prop="changedField" />
      <el-table-column label="原值" align="center" prop="oldValue" />
      <el-table-column label="新值" align="center" prop="newValue" />
      <el-table-column label="变更时间" align="center" prop="changeTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.changeTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作人员" align="center" prop="operatorId" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['factory:factoryHistory:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['factory:factoryHistory:remove']"
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

    <!-- 添加或修改工厂变更历史对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="关联工厂" prop="factoryId">
          <el-input v-model="form.factoryId" placeholder="请输入关联工厂" />
        </el-form-item>
        <el-form-item label="变更字段" prop="changedField">
          <el-input v-model="form.changedField" placeholder="请输入变更字段" />
        </el-form-item>
        <el-form-item label="原值" prop="oldValue">
          <el-input v-model="form.oldValue" placeholder="请输入原值" />
        </el-form-item>
        <el-form-item label="新值" prop="newValue">
          <el-input v-model="form.newValue" placeholder="请输入新值" />
        </el-form-item>
        <el-form-item label="变更时间" prop="changeTime">
          <el-date-picker clearable
            v-model="form.changeTime"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择变更时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="操作人员" prop="operatorId">
          <el-input v-model="form.operatorId" placeholder="请输入操作人员" />
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
import { listFactoryHistory, getFactoryHistory, delFactoryHistory, addFactoryHistory, updateFactoryHistory } from "@/api/factory/factoryHistory";

export default {
  name: "FactoryHistory",
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
      // 工厂变更历史表格数据
      factoryHistoryList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        factoryId: null,
        changedField: null,
        oldValue: null,
        newValue: null,
        changeTime: null,
        operatorId: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        logId: [
          { required: true, message: "日志ID不能为空", trigger: "blur" }
        ],
        factoryId: [
          { required: true, message: "关联工厂不能为空", trigger: "blur" }
        ],
        changedField: [
          { required: true, message: "变更字段不能为空", trigger: "blur" }
        ],
        newValue: [
          { required: true, message: "新值不能为空", trigger: "blur" }
        ],
        operatorId: [
          { required: true, message: "操作人员不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询工厂变更历史列表 */
    getList() {
      this.loading = true;
      listFactoryHistory(this.queryParams).then(response => {
        this.factoryHistoryList = response.rows;
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
        factoryId: null,
        changedField: null,
        oldValue: null,
        newValue: null,
        changeTime: null,
        operatorId: null
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
      this.title = "添加工厂变更历史";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const logId = row.logId || this.ids
      getFactoryHistory(logId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改工厂变更历史";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.logId != null) {
            updateFactoryHistory(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addFactoryHistory(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除工厂变更历史编号为"' + logIds + '"的数据项？').then(function() {
        return delFactoryHistory(logIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('factory/factoryHistory/export', {
        ...this.queryParams
      }, `factoryHistory_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
