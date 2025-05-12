<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <!-- <el-form-item label="工厂ID" prop="factoryId">
        <el-input v-model="queryParams.factoryId" placeholder="请输入工厂ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item> -->
      <el-form-item label="工厂名" prop="factoryName">
        <el-input v-model="queryParams.factoryName" placeholder="请输入工厂名" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="关联用户ID" prop="userId" v-if="isAdmin">
        <el-input v-model="queryParams.userId" placeholder="请输入关联用户ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="上衣产能" prop="capacityTop">
        <el-input v-model="queryParams.capacityTop" placeholder="请输入上衣产能" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="裤子产能" prop="capacityPants">
        <el-input v-model="queryParams.capacityPants" placeholder="请输入裤子产能" clearable
          @keyup.enter.native="handleQuery" />
      </el-form-item>
      <!-- <el-form-item label="上衣成本" prop="costTop">
        <el-input v-model="queryParams.costTop" placeholder="请输入上衣成本" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="裤子成本" prop="costPants">
        <el-input v-model="queryParams.costPants" placeholder="请输入裤子成本" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="上衣良品率" prop="qualityTop">
        <el-input v-model="queryParams.qualityTop" placeholder="请输入上衣良品率" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="裤子良品率" prop="qualityPants">
        <el-input v-model="queryParams.qualityPants" placeholder="请输入裤子良品率" clearable
          @keyup.enter.native="handleQuery" />
      </el-form-item> -->
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd"
          v-hasPermi="['factory:factorys:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate"
          v-hasPermi="['factory:factorys:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['factory:factorys:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport"
          v-hasPermi="['factory:factorys:export']">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="factorysList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="工厂ID" align="center" prop="factoryId" />
      <el-table-column label="工厂名" align="center" prop="factoryName" />
      <el-table-column label="关联用户ID" align="center" prop="userId" />
      <el-table-column label="上衣产能" align="center" prop="capacityTop" />
      <el-table-column label="裤子产能" align="center" prop="capacityPants" />
      <el-table-column label="上衣成本" align="center" prop="costTop" />
      <el-table-column label="裤子成本" align="center" prop="costPants" />
      <el-table-column label="上衣良品率" align="center" prop="qualityTop" />
      <el-table-column label="裤子良品率" align="center" prop="qualityPants" />
      <el-table-column label="工厂状态" align="center">
  <template slot-scope="scope">
    <el-tag :type="scope.row.isActive? 'success' : 'danger'">
      {{ scope.row.isActive? '启用' : '停用' }}
    </el-tag>
  </template>
</el-table-column> 
      <!-- <el-table-column label="工作时间表" align="center" prop="workSchedule" /> -->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-picture" @click="showImage(scope.row)">查看生产计划</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['factory:factorys:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)"
            v-hasPermi="['factory:factorys:remove']">删除</el-button>
            <el-button 
      size="mini" 
      :type="scope.row.isActive ? 'danger' : 'success'" 
      icon="el-icon-switch-button" 
      @click="handleStatusChange(scope.row)"
      v-hasPermi="['factory:factorys:edit']">
      {{ scope.row.isActive ? '停用' : '启用' }}
    </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
      @pagination="getList" />

    <!-- 添加或修改工厂信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="工厂名" prop="factoryName">
          <el-input v-model="form.factoryName" placeholder="请输入工厂名" />
        </el-form-item>
        <el-form-item label="关联用户ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入关联用户ID" :disabled="!isAdmin" />
        </el-form-item>
        <el-form-item label="工厂状态" prop="isActive">
  <el-switch
    v-model="form.isActive"
    active-text="启用"
    inactive-text="停用"
    :active-value="true"
    :inactive-value="false">
  </el-switch>
</el-form-item>
        <el-form-item label="上衣产能" prop="capacityTop">
          <el-input v-model="form.capacityTop" placeholder="请输入上衣产能" />
        </el-form-item>
        <el-form-item label="裤子产能" prop="capacityPants">
          <el-input v-model="form.capacityPants" placeholder="请输入裤子产能" />
        </el-form-item>
        <el-form-item label="上衣成本" prop="costTop">
          <el-input v-model="form.costTop" placeholder="请输入上衣成本" />
        </el-form-item>
        <el-form-item label="裤子成本" prop="costPants">
          <el-input v-model="form.costPants" placeholder="请输入裤子成本" />
        </el-form-item>
        <el-form-item label="上衣良品率" prop="qualityTop">
          <el-input v-model="form.qualityTop" placeholder="请输入上衣良品率" />
        </el-form-item>
        <el-form-item label="裤子良品率" prop="qualityPants">
          <el-input v-model="form.qualityPants" placeholder="请输入裤子良品率" />
        </el-form-item>
        <el-form-item label="工作时间表" prop="workSchedule">
          <file-upload v-model="form.workSchedule" />
        </el-form-item>
        <el-divider content-position="center">工厂变更历史信息</el-divider>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddFactoryHistory">添加</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" icon="el-icon-delete" size="mini"
              @click="handleDeleteFactoryHistory">删除</el-button>
          </el-col>
        </el-row>
        <el-table :data="factoryHistoryList" :row-class-name="rowFactoryHistoryIndex"
          @selection-change="handleFactoryHistorySelectionChange" ref="factoryHistory">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="序号" align="center" prop="index" width="50" />
          <el-table-column label="变更字段" prop="changedField" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.changedField" placeholder="请输入变更字段" />
            </template>
          </el-table-column>
          <el-table-column label="原值" prop="oldValue" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.oldValue" placeholder="请输入原值" />
            </template>
          </el-table-column>
          <el-table-column label="新值" prop="newValue" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.newValue" placeholder="请输入新值" />
            </template>
          </el-table-column>
          <el-table-column label="变更时间" prop="changeTime" width="240">
            <template slot-scope="scope">
              <el-date-picker clearable v-model="scope.row.changeTime" type="date" value-format="yyyy-MM-dd"
                placeholder="请选择变更时间" />
            </template>
          </el-table-column>
          <el-table-column label="操作人员" prop="operatorId" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.operatorId" placeholder="请输入操作人员" />
            </template>
          </el-table-column>
        </el-table>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog 
    :visible.sync="imageDialogVisible"
    width="80%"
    :close-on-click-modal="false"
    :destroy-on-close="true" 
    @closed="handleCloseImage"
    custom-class="fullscreen-image-dialog">
    
    <!-- 使用v-if确保每次重新创建 -->
    <div v-if="imageDialogVisible" class="image-wrapper">
      <el-image 
        :key="imageKey" 
        :src="currentImageUrl"
        :preview-src-list="[currentImageUrl]"
    fit="contain" 
    style="width: 100%; height: 60vh">
    <div slot="error" class="image-slot">
      <i class="el-icon-picture-outline"></i>
      <span>暂无图片</span>
    </div>
  </el-image>
    </div>
</el-dialog>
  </div>
</template>

<script>
import { listFactorys, getFactorys, delFactorys, addFactorys, updateFactorys } from "@/api/factory/factorys";
import { getUserProfile } from "@/api/system/user";

export default {
  name: "Factorys",
  data() {
    return {
      imageDialogVisible: false, // 控制图片对话框显示
    currentImageUrl: '',
    imageKey: 0, // 新增key值用于强制刷新
      user: {},
      isAdmin: false,
      // 遮罩层
      loading: false,
      // 选中数组
      ids: [],
      // 子表选中数据
      checkedFactoryHistory: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 工厂信息表格数据
      factorysList: [],
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
        factoryName: null,
        userId: null,
        capacityTop: null,
        capacityPants: null,
        costTop: null,
        costPants: null,
        qualityTop: null,
        qualityPants: null,
        isActive: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        factoryName: [
          { required: true, message: "工厂名不能为空",  trigger: "blur" }
        ],
        userId: [
          { required: true, message: "关联用户ID不能为空", trigger: "blur" }
        ],
        capacityTop: [
          { required: true, message: "上衣产能不能为空", trigger: "blur" }
        ],
        capacityPants: [
          { required: true, message: "裤子产能不能为空", trigger: "blur" }
        ],
        costTop: [
          { required: true, message: "上衣成本不能为空", trigger: "blur" }
        ],
        costPants: [
          { required: true, message: "裤子成本不能为空", trigger: "blur" }
        ],
        qualityTop: [
          { required: true, message: "上衣良品率不能为空", trigger: "blur" }
        ],
        qualityPants: [
          { required: true, message: "裤子良品率不能为空", trigger: "blur" }
        ],
        isActive: [
    { required: true, message: "状态不能为空", trigger: "blur" }
  ],
      }
    };
  },
  async created() {
    await this.getUser();
    this.getList();
  },
  methods: {
    showImage(row) {
    // 根据工厂ID拼接图片路径（根据实际情况调整路径）
    this.currentImageUrl = `/factory_images/factory_${row.factoryId}.png?t=${Date.now()}`
    this.imageKey = Date.now() // 强制重新创建组件
    this.imageDialogVisible = true
  },
    // 状态修改
handleStatusChange(row) {
  const text = row.isActive ? "停用" : "启用";
  this.$modal.confirm(`确认要${text}【${row.factoryName}】吗？`).then(() => {
    const newStatus = !row.isActive;
    updateFactorys({
      ...row,
      isActive: newStatus
    }).then(() => {
    this.$modal.msgSuccess(`${text}成功`);
    // 直接更新当前行的状态，避免重新请求整个列表
    this.$set(row, 'isActive', newStatus);
  });
  this.getList();
  }).catch(() => {});
},
    /** 查询工厂信息列表 */
    async getList() {

      const params = {
        ...this.queryParams,
        userId: this.isAdmin ? null : this.user.userId // 关键过滤逻辑
      };
      const res = await listFactorys(params);
      this.factorysList = res.rows;
      this.total = response.total
    },
    
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        factoryId: null,
        factoryName: null,
        userId: null,
        capacityTop: null,
        capacityPants: null,
        costTop: null,
        costPants: null,
        qualityTop: null,
        qualityPants: null,
        isActive: null,
        workSchedule: null
      };
      this.factoryHistoryList = [];
      this.resetForm("form");
    },
    /** 获取当前用户信息 */
    async getUser() {
      const res = await getUserProfile();
      this.user = res.data;
      this.isAdmin = res.roleGroup.includes("超级管理员") || res.roleGroup.includes("平台管理员");
      
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
      this.ids = selection.map(item => item.factoryId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加工厂信息";

      // 非管理员自动填充用户ID
      if (!this.isAdmin) {
        this.$set(this.form, 'userId', this.user.userId);
      }
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const factoryId = row.factoryId || this.ids
      getFactorys(factoryId).then(response => {
        this.form = response.data;
        this.factoryHistoryList = response.data.factoryHistoryList;
        this.open = true;
        this.title = "修改工厂信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.factoryHistoryList = this.factoryHistoryList;
          if (this.form.factoryId != null) {
            updateFactorys(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addFactorys(this.form).then(response => {
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
      const factoryIds = row.factoryId || this.ids;
      this.$modal.confirm('是否确认删除工厂信息编号为"' + factoryIds + '"的数据项？').then(()=>{
        return delFactorys(factoryIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => { });
    },
    /** 工厂变更历史序号 */
    rowFactoryHistoryIndex({ row, rowIndex }) {
      row.index = rowIndex + 1;
    },
    /** 工厂变更历史添加按钮操作 */
    handleAddFactoryHistory() {
      let obj = {};
      obj.changedField = "";
      obj.oldValue = "";
      obj.newValue = "";
      obj.changeTime = "";
      obj.operatorId = "";
      this.factoryHistoryList.push(obj);
    },
    /** 工厂变更历史删除按钮操作 */
    handleDeleteFactoryHistory() {
      if (this.checkedFactoryHistory.length == 0) {
        this.$modal.msgError("请先选择要删除的工厂变更历史数据");
      } else {
        const factoryHistoryList = this.factoryHistoryList;
        const checkedFactoryHistory = this.checkedFactoryHistory;
        this.factoryHistoryList = factoryHistoryList.filter(function (item) {
          return checkedFactoryHistory.indexOf(item.index) == -1
        });
      }
    },
    /** 复选框选中数据 */
    handleFactoryHistorySelectionChange(selection) {
      this.checkedFactoryHistory = selection.map(item => item.index)
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('factory/factorys/export', {
        ...this.queryParams
      }, `factorys_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
