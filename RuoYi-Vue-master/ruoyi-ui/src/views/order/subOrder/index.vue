<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="主订单ID" prop="orderId">
        <el-input
          v-model="queryParams.orderId"
          placeholder="请输入主订单ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="产品类型" prop="productId">
        <el-input
          v-model="queryParams.productId"
          placeholder="请输入产品类型"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="订购数量" prop="quantity">
        <el-input
          v-model="queryParams.quantity"
          placeholder="请输入订购数量"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="交货期限">
        <el-date-picker
          v-model="daterangeDeadline"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="质量要求" prop="qualityStandard">
        <el-input
          v-model="queryParams.qualityStandard"
          placeholder="请输入质量要求"
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
          v-hasPermi="['order:subOrder:add']"
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
          v-hasPermi="['order:subOrder:edit']"
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
          v-hasPermi="['order:subOrder:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['order:subOrder:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="subOrderList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="主订单ID" align="center" prop="orderId" />
      <el-table-column label="子订单ID" align="center" prop="subOrderId" />
      <el-table-column label="产品类型" align="center" prop="productId" />
      <el-table-column label="订购数量" align="center" prop="quantity" />
      <el-table-column label="交货期限" align="center" prop="deadline" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.deadline, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="质量要求" align="center" prop="qualityStandard" />
      <el-table-column label="生产要求文件" align="center" prop="productionFile" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['order:subOrder:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['order:subOrder:remove']"
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

    <!-- 添加或修改子订单列表对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="主订单ID" prop="orderId">
          <el-input v-model="form.orderId" placeholder="请输入主订单ID" />
        </el-form-item>
        <el-form-item label="产品类型" prop="productId">
          <el-input v-model="form.productId" placeholder="请输入产品类型" />
        </el-form-item>
        <el-form-item label="订购数量" prop="quantity">
          <el-input v-model="form.quantity" placeholder="请输入订购数量" />
        </el-form-item>
        <el-form-item label="交货期限" prop="deadline">
          <el-date-picker clearable
            v-model="form.deadline"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择交货期限">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="质量要求" prop="qualityStandard">
          <el-input v-model="form.qualityStandard" placeholder="请输入质量要求" />
        </el-form-item>
        <el-form-item label="生产要求文件" prop="productionFile">
          <file-upload v-model="form.productionFile"/>
        </el-form-item>
        <el-divider content-position="center">生产计划信息</el-divider>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddProductionPlan">添加</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteProductionPlan">删除</el-button>
          </el-col>
        </el-row>
        <el-table :data="productionPlanList" :row-class-name="rowProductionPlanIndex" @selection-change="handleProductionPlanSelectionChange" ref="productionPlan">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="序号" align="center" prop="index" width="50"/>
          <el-table-column label="生产工厂" prop="factoryId" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.factoryId" placeholder="请输入生产工厂" />
            </template>
          </el-table-column>
          <el-table-column label="计划开始日期" prop="startDate" width="240">
            <template slot-scope="scope">
              <el-date-picker clearable v-model="scope.row.startDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择计划开始日期" />
            </template>
          </el-table-column>
          <el-table-column label="计划完成日期" prop="endDate" width="240">
            <template slot-scope="scope">
              <el-date-picker clearable v-model="scope.row.endDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择计划完成日期" />
            </template>
          </el-table-column>
          <el-table-column label="实际完成日期" prop="actualEndDate" width="240">
            <template slot-scope="scope">
              <el-date-picker clearable v-model="scope.row.actualEndDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择实际完成日期" />
            </template>
          </el-table-column>
          <el-table-column label="当前状态" prop="currentStatus" width="150">
            <template slot-scope="scope">
              <el-select v-model="scope.row.currentStatus" placeholder="请选择当前状态">
                <el-option label="请选择字典生成" value="" />
              </el-select>
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
import { listSubOrder, getSubOrder, delSubOrder, addSubOrder, updateSubOrder } from "@/api/order/subOrder";

export default {
  name: "SubOrder",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 子表选中数据
      checkedProductionPlan: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 子订单列表表格数据
      subOrderList: [],
      // 生产计划表格数据
      productionPlanList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 当前状态时间范围
      daterangeDeadline: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        orderId: null,
        productId: null,
        quantity: null,
        deadline: null,
        qualityStandard: null,
        productionFile: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        orderId: [
          { required: true, message: "主订单ID不能为空", trigger: "blur" }
        ],
        productId: [
          { required: true, message: "产品类型不能为空", trigger: "blur" }
        ],
        quantity: [
          { required: true, message: "订购数量不能为空", trigger: "blur" }
        ],
        deadline: [
          { required: true, message: "交货期限不能为空", trigger: "blur" }
        ],
        qualityStandard: [
          { required: true, message: "质量要求不能为空", trigger: "blur" }
        ],
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询子订单列表列表 */
    getList() {
      this.loading = true;
      this.queryParams.params = {};
      if (null != this.daterangeDeadline && '' != this.daterangeDeadline) {
        this.queryParams.params["beginDeadline"] = this.daterangeDeadline[0];
        this.queryParams.params["endDeadline"] = this.daterangeDeadline[1];
      }
      listSubOrder(this.queryParams).then(response => {
        this.subOrderList = response.rows;
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
        subOrderId: null,
        orderId: null,
        productId: null,
        quantity: null,
        deadline: null,
        qualityStandard: null,
        productionFile: null
      };
      this.productionPlanList = [];
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.daterangeDeadline = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.subOrderId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加子订单列表";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const subOrderId = row.subOrderId || this.ids
      getSubOrder(subOrderId).then(response => {
        this.form = response.data;
        this.productionPlanList = response.data.productionPlanList;
        this.open = true;
        this.title = "修改子订单列表";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.productionPlanList = this.productionPlanList;
          if (this.form.subOrderId != null) {
            updateSubOrder(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addSubOrder(this.form).then(response => {
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
      const subOrderIds = row.subOrderId || this.ids;
      this.$modal.confirm('是否确认删除子订单列表编号为"' + subOrderIds + '"的数据项？').then(function() {
        return delSubOrder(subOrderIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
	/** 生产计划序号 */
    rowProductionPlanIndex({ row, rowIndex }) {
      row.index = rowIndex + 1;
    },
    /** 生产计划添加按钮操作 */
    handleAddProductionPlan() {
      let obj = {};
      obj.factoryId = "";
      obj.startDate = "";
      obj.endDate = "";
      obj.actualEndDate = "";
      obj.dailyProgress = "";
      obj.currentStatus = "";
      this.productionPlanList.push(obj);
    },
    /** 生产计划删除按钮操作 */
    handleDeleteProductionPlan() {
      if (this.checkedProductionPlan.length == 0) {
        this.$modal.msgError("请先选择要删除的生产计划数据");
      } else {
        const productionPlanList = this.productionPlanList;
        const checkedProductionPlan = this.checkedProductionPlan;
        this.productionPlanList = productionPlanList.filter(function(item) {
          return checkedProductionPlan.indexOf(item.index) == -1
        });
      }
    },
    /** 复选框选中数据 */
    handleProductionPlanSelectionChange(selection) {
      this.checkedProductionPlan = selection.map(item => item.index)
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('order/subOrder/export', {
        ...this.queryParams
      }, `subOrder_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
