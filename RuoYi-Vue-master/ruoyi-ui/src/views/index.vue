<template>
  <div class="app-container">
    <h3 style="margin-bottom: 20px">数据看板</h3>
    <el-row :gutter="20">
      <!-- 用户统计 -->
      <el-col :span="8">
        <el-card>
          <div slot="header" class="card-header">用户统计</div>
          <div class="card-content">
            <div class="total-item">总用户数：{{ userTotal }}</div>
            <div id="roleChart" style="height: 300px"></div>
          </div>
        </el-card>
      </el-col>

      <!-- 工厂统计 -->
      <el-col :span="8">
        <el-card>
          <div slot="header" class="card-header">工厂统计</div>
          <div class="card-content">
            <div class="total-item">总工厂数：{{ factoryTotal }}</div>
            <div id="factoryChart" style="height: 300px"></div>
          </div>
        </el-card>
      </el-col>

      <!-- 订单统计 -->
      <el-col :span="8">
        <el-card>
          <div slot="header" class="card-header">订单统计</div>
          <div class="card-content">
            <div class="total-item">总订单数：{{ orderTotal }}</div>
            <div id="orderChart" style="height: 300px"></div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { listUser } from "@/api/system/user";
import { listFactorys } from "@/api/factory/factorys";
import { listOrders } from "@/api/order/orders";
import * as echarts from 'echarts';

export default {
  name: "Dashboard",
  data() {
    return {
      userTotal: 0,
      factoryTotal: 0,
      orderTotal: 0,
      roleChart: null,
      factoryChart: null,
      orderChart: null
    };
  },
  async mounted() {
    await this.loadData();
    this.initCharts();
  },
  beforeDestroy() {
    if (this.roleChart) echarts.dispose(this.roleChart);
    if (this.factoryChart) echarts.dispose(this.factoryChart);
    if (this.orderChart) echarts.dispose(this.orderChart);
  },
  methods: {
    async loadData() {
      // 用户数据
      const users = await listUser({ pageSize: 1000 });
      this.userTotal = users.total;

      // 工厂数据
      const factories = await listFactorys({ pageSize: 1000 });
      this.factoryTotal = factories.total;

      // 订单数据
      const orders = await listOrders({ pageSize: 1000 });
      this.orderTotal = orders.total;

      // 处理图表数据
      this.roleData = this.processRoleData(users.rows);
      this.factoryData = this.processFactoryData(factories.rows);
      this.orderData = this.processOrderData(orders.rows);
    },

    processRoleData(users) {
  // 新版统计逻辑（兼容字符串和数组格式）
  return users.reduce((acc, user) => {
    let role = '';
    
    // 处理不同数据格式
    if (Array.isArray(user.roleGroup)) {
      role = user.roleGroup[0] || '总用户数';
    } else if (typeof user.roleGroup === 'string') {
      role = user.roleGroup.split(',')[0] || '总用户数';
    } else {
      role = '总用户数';
    }

    acc[role] = (acc[role] || 0) + 1;
    return acc;
  }, {});
},


    processFactoryData(factories) {
      return factories.reduce((acc, cur) => {
        const status = cur.isActive ? '启用' : '停用';
        acc[status] = (acc[status] || 0) + 1;
        return acc;
      }, {});
    },


    processOrderData(orders) {
      return orders.reduce((acc, cur) => {
        acc[cur.status] = (acc[cur.status] || 0) + 1;
        return acc;
      }, {});
    },

    initCharts() {
      this.initRoleChart();
      this.initFactoryChart();
      this.initOrderChart();
    },

    initRoleChart() {
  this.roleChart = echarts.init(document.getElementById('roleChart'));
  const chartData = Object.entries(this.roleData).map(([name, value]) => ({
    name,
    value,
    itemStyle: {
      color: this.getRoleColor(name) // 根据角色分配颜色
    }
  }));

  this.roleChart.setOption({
    title: { text: '用户统计', left: 'center' },
    tooltip: { trigger: 'item' },
    legend: {
      orient: 'vertical',
      left: 'left',
      data: Object.keys(this.roleData)
    },
    series: [{
      type: 'pie',
      radius: '60%',
      data: chartData,
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      },
      label: {
        formatter: '{b}: {c} ({d}%)' // 显示名称、数量和百分比
      }
    }]
  });
},

    initFactoryChart() {
      this.factoryChart = echarts.init(document.getElementById('factoryChart'));
      this.factoryChart.setOption({
        title: { text: '工厂状态', left: 'center' },
        xAxis: {
          type: 'category',
          data: Object.keys(this.factoryData),
          axisLabel: {
            formatter: value => value.replace('', '\n') // 换行显示长标签
          }
        },
        yAxis: { type: 'value' },
        series: [{
          type: 'bar',
          data: Object.keys(this.factoryData).map(status => ({
            value: this.factoryData[status],
            itemStyle: {
              color: status === '启用' ? '#67C23A' : '#F56C6C' // 启用绿色，停用红色
            }
          })),
          label: {
            show: true,
            position: 'top'
          }
        }]
      });
    },

    initOrderChart() {
      this.orderChart = echarts.init(document.getElementById('orderChart'));
      this.orderChart.setOption({
        title: { text: '订单状态', left: 'center' },
        tooltip: { trigger: 'item' },
        series: [{
          type: 'pie',
          data: Object.entries(this.orderData).map(([name, value]) => ({
            name: this.formatOrderStatus(name),
            value
          })),
          emphasis: { itemStyle: { shadowBlur: 10 } }
        }]
      });
    },

    formatOrderStatus(status) {
      const map = {
        'PENDING': '待处理',
        'PROCESSING': '进行中',
        'COMPLETED': '已完成',
        'CANCELLED': '已取消'
      };
      return map[status] || status;
    },

    getRoleColor(roleName) {
  const colorMap = {
    '超级管理员': '#FF0066',
    '平台管理员': '#36A2EB',
    '工厂用户': '#4BC0C0',
    '消费者': '#FFCE56',
    'roleChart': '#FF0066'
  };
  return colorMap[roleName] || '#CCCCCC';
}
  }
};
</script>

<style scoped>
.card-header {
  font-weight: bold;
  font-size: 16px;
}

.card-content {
  padding: 15px;
}

.total-item {
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}
</style>