<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="订单ID" prop="orderId">
        <el-input v-model="queryParams.orderId" placeholder="请输入订单ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="客户ID" prop="customerId">
        <el-input v-model="queryParams.customerId" placeholder="请输入客户ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="下单时间">
        <el-date-picker v-model="daterangeCreateTime" style="width: 240px" value-format="yyyy-MM-dd" type="daterange"
          range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item label="取消原因" prop="cancelReason">
        <el-input v-model="queryParams.cancelReason" placeholder="请输入取消原因" clearable
          @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="订单总金额" prop="totalAmount">
        <el-input v-model="queryParams.totalAmount" placeholder="请输入订单总金额" clearable
          @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd"
          v-hasPermi="['order:orders:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate"
          v-hasPermi="['order:orders:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['order:orders:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport"
          v-hasPermi="['order:orders:export']">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="ordersList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="订单ID" align="center" prop="orderId" />
      <el-table-column label="客户ID" align="center" prop="customerId" />
      <el-table-column label="客户名称" align="center" prop="customerName" />
      <el-table-column label="订单状态" align="center" prop="status" />
      <el-table-column label="取消原因" align="center" prop="cancelReason" />
      <el-table-column label="订单预算" align="center" prop="totalAmount" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit"
            :type="scope.row.status !== 'PENDING' ? 'info' : 'primary'" @click="handleUpdate(scope.row)"
            v-hasPermi="['order:orders:edit']">{{ scope.row.status === 'PENDING' ? '修改' : '查看' }}</el-button>

          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)"
            v-hasPermi="['order:orders:remove']">删除</el-button>

          <!-- 新增取消订单按钮 -->
          <el-button v-if="scope.row.status === 'PENDING'" size="mini" type="text" icon="el-icon-close"
            style="color: #f56c6c;" @click="handleCancelOrder(scope.row)"
            v-hasPermi="['order:orders:cancel']">取消订单</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
      @pagination="getList" />

    <!-- 添加或修改订单列表对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="1200px" append-to-body class="custom-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="客户ID" prop="customerId">
              <el-input v-model="form.customerId" placeholder="自动填充" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="订单预算" prop="totalAmount">
              <el-input-number v-model="form.totalAmount" :precision="2" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-divider content-position="center">子订单列表信息</el-divider>
            <el-row :gutter="10" class="mb8">
              <el-col :span="1.5">
                <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddSubOrder">添加</el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteSubOrder">删除</el-button>
              </el-col>
            </el-row>
            <el-table :data="subOrderList" :row-class-name="rowSubOrderIndex"
              @selection-change="handleSubOrderSelectionChange" ref="subOrder">
              <el-table-column type="selection" width="50" align="center" />
              <el-table-column label="序号" align="center" prop="index" width="50" />
              <el-table-column label="产品类型" prop="productId" width="150">
                <template slot-scope="scope">
                  <el-select v-model="scope.row.productId" placeholder="请选择产品类型" :disabled="title === '查看订单'">
                    <el-option v-for="item in productOptions" :key="item.productId" :label="item.typeName"
                      :value="item.productId" />
                  </el-select>
                </template>
              </el-table-column>

              <el-table-column label="订购数量" prop="quantity" width="220">
                <template slot-scope="scope">
                  <el-input-number v-model="scope.row.quantity" :min="1" :disabled="title === '查看订单'" />
                </template>
              </el-table-column>
              <el-table-column label="交货期限" prop="deadline" width="240">
                <template slot-scope="scope">
                  <el-date-picker clearable v-model="scope.row.deadline" type="date" value-format="yyyy-MM-dd"
                    placeholder="请选择交货期限" />
                </template>
              </el-table-column>
              <el-table-column label="质量要求" prop="qualityStandard" width="200">
                <template slot-scope="scope">
                  <el-slider v-model="scope.row.qualityStandard" :min="0" :max="1" :step="0.01" show-input-controls
                    :disabled="title === '查看订单'"></el-slider>
                </template>
              </el-table-column>
              <el-table-column label="生产要求文件" prop="productionFile" width="300">
                <template slot-scope="scope">
                  <file-upload v-model="scope.row.productionFile" />
                </template>
              </el-table-column>
            </el-table>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 添加取消订单对话框 -->
    <el-dialog title="取消订单" :visible.sync="cancelDialogVisible" width="500px">
      <el-form :model="cancelForm">
        <el-form-item label="取消原因" prop="reason">
          <el-input v-model="cancelForm.reason" type="textarea" :rows="3" placeholder="请输入详细的取消原因"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="cancelDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitCancel">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listOrders, getOrders, delOrders, addOrders, updateOrders } from "@/api/order/orders";
import { getUserProfile } from "@/api/system/user";
export default {
  name: "Orders",
  data() {
    return {
      // 从后端获取产品类型
      productOptions: [],
      //是否为超级管理员
      isAdmin: false,
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 子表选中数据
      checkedSubOrder: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 订单列表表格数据
      ordersList: [],
      // 子订单列表表格数据
      subOrderList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 生产要求文件时间范围
      daterangeCreateTime: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        orderId: null,
        customerId: null,
        createTime: null,
        status: null,
        cancelReason: null,
        totalAmount: null,

      },
      //取消功能
      cancelForm: {
        orderId: null,
        reason: ''
      },
      cancelDialogVisible: false,
      //用户信息
      user: {},
      roleGroup: {},
      postGroup: {},
      activeTab: "userinfo",
      // 表单参数
      form: {
        productionFile: null
      },
      // 表单校验
      rules: {
        customerId: [
          { required: true, message: "客户ID不能为空", trigger: "blur" }
        ],
        createTime: [
          { required: true, message: "下单时间不能为空", trigger: "blur" }
        ],
        productionFile: [
          { required: true, message: "请上传生产要求文件", trigger: "blur" }
        ],
      }
    };
  },
  async created() {
    await this.getUser();
    this.getProductTypes();
    this.getList();
  },
  methods: {
    //获取产品类型
    getProductTypes() {
      this.productOptions = [
        { "productId": 1, "typeName": "上衣" },
        { "productId": 2, "typeName": "裤子" }
      ]
    },
    //获取用户数据
    /** 获取当前用户信息 */
    async getUser() {
      const res = await getUserProfile();
      this.user = res.data;
      this.isAdmin = res.roleGroup.includes("超级管理员") || res.roleGroup.includes("平台管理员");
    },
    /** 查询订单列表列表 */
    getList() {
      this.loading = true;

      // 正确传递用户ID（直接作为顶级参数）
      const params = {
        ...this.queryParams,
        beginCreateTime: this.daterangeCreateTime?.length ? this.daterangeCreateTime[0] : null,
        endCreateTime: this.daterangeCreateTime?.length ? this.daterangeCreateTime[1] : null
      };

      if (!this.isAdmin) {
        params.customerId = this.user.userId;
        this.queryParams.customerId = this.user.userId;
      }

      listOrders(params).then(response => { // 注意这里传递修改后的params
        this.ordersList = response.rows;
        //this.$modal.msgSuccess(this.ordersList);
        this.total = response.total;
        this.loading = false;
      }).catch(() => {
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
        orderId: null,
        customerId: null,
        createTime: null,
        status: null,
        cancelReason: null,
        totalAmount: null
      };
      this.subOrderList = [];
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.daterangeCreateTime = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.orderId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加订单列表";
      this.$set(this.form, 'customerId', this.user.userId);
    },
    /** 修改按钮操作 */
    // handleUpdate(row) {
    //   this.reset();
    //   const orderId = row.orderId || this.ids
    //   getOrders(orderId).then(response => {
    //     this.form = response.data;
    //     this.subOrderList = response.data.subOrderList;
    //     this.open = true;
    //     this.title = "修改订单列表";
    //   });
    // },
    handleUpdate(row) {
      this.reset();
      const orderId = row.orderId || this.ids;
      getOrders(orderId).then(response => {
        this.form = response.data;
        this.subOrderList = response.data.subOrderList;
        this.open = true;
        this.title = row.status === 'PENDING' ? '修改订单' : '查看订单';

        // 非PENDING状态禁用表单
        if (row.status !== 'PENDING') {
          this.$nextTick(() => {
            const formItems = this.$refs.form.$el.querySelectorAll('.el-input__inner');
            formItems.forEach(item => item.setAttribute('disabled', true));
          });
        }
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.subOrderList = this.subOrderList;
          if (this.form.orderId != null) {
            updateOrders(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addOrders(this.form).then(response => {
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
      const orderIds = row.orderId || this.ids;
      this.$modal.confirm('是否确认删除订单列表编号为"' + orderIds + '"的数据项？').then(function () {
        return delOrders(orderIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => { });
    },
    /** 子订单列表序号 */
    rowSubOrderIndex({ row, rowIndex }) {
      row.index = rowIndex + 1;
    },
    /** 子订单列表添加按钮操作 */
    handleAddSubOrder() {
      let obj = {};
      obj.productId = "";
      obj.quantity = "";
      obj.deadline = "";
      obj.qualityStandard = "";
      obj.productionFile = "";
      this.subOrderList.push(obj);
    },
    /** 子订单列表删除按钮操作 */
    handleDeleteSubOrder() {
      if (this.checkedSubOrder.length == 0) {
        this.$modal.msgError("请先选择要删除的子订单列表数据");
      } else {
        const subOrderList = this.subOrderList;
        const checkedSubOrder = this.checkedSubOrder;
        this.subOrderList = subOrderList.filter(function (item) {
          return checkedSubOrder.indexOf(item.index) == -1
        });
      }
    },
    /** 复选框选中数据 */
    handleSubOrderSelectionChange(selection) {
      this.checkedSubOrder = selection.map(item => item.index)
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('order/orders/export', {
        ...this.queryParams
      }, `orders_${new Date().getTime()}.xlsx`)
    },
    // 取消订单操作
    handleCancelOrder(row) {
      this.cancelForm.orderId = row.orderId;
      this.cancelDialogVisible = true;
    },

    // 提交取消原因
    submitCancel() {
      if (!this.cancelForm.reason) {
        this.$modal.msgWarning("请输入取消原因");
        return;
      }

      updateOrders({
        orderId: this.cancelForm.orderId,
        status: 'CANCELLED',
        cancelReason: this.cancelForm.reason
      }).then(() => {
        this.$modal.msgSuccess("订单已取消");
        this.cancelDialogVisible = false;
        this.getList();
      });
    }
  }
};
//this.getList();
</script>
