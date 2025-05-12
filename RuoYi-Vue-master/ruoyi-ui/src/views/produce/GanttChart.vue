<template>
  <div class="gantt-container">
    <div v-if="loading" class="loading">加载中...</div>
    <div v-else class="echarts-box">
    <div ref="ganttChart" style="width: 100%; height: 600px"></div>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts';
import { getPlanDetail } from "@/api/produce/plan";

export default {
  name: "GanttChart",
  props: {
    planId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      loading: true,
      chart: null,
      planData: []  // 改为数组，支持多个工厂/子订单
    };
  },
  async mounted() {
    await this.loadData();
    this.initChart();
  },
  methods: {
    async loadData() {
      try {
        const response = await getPlanDetail(this.planId);
        // 假设后端返回数组格式（支持多子订单）
        this.planData = response.data; 
        this.loading = false;
      } catch (error) {
        console.error("数据加载失败:", error);
      }
    },

    initChart() {
      this.chart = echarts.init(this.$refs.ganttChart);
      const option = {
        tooltip: {
          formatter: (params) => {
            const data = params.data;
            return `
              <strong>子订单ID: ${data.subOrderId}</strong><br/>
              客户: ${data.customerName}<br/>
              数量: ${data.quantity}件<br/>
              质量要求: ${data.qualityStandard}%<br/>
              工厂: ${data.factoryName}（ID: ${data.factoryId}）<br/>
              今日进度: ${data.dailyProgress[new Date().toISOString().split('T')[0]] || 0}件
            `;
          }
        },
        xAxis: {
          type: 'time',
          name: '时间',
          axisLabel: {
            formatter: (value) => echarts.format.formatTime('yyyy-MM-dd', value)
          }
        },
        yAxis: {
          type: 'category',
          data: [...new Set(this.planData.map(item => item.factoryName))],  // 去重工厂名称
          name: '工厂'
        },
        series: [{
          type: 'bar',
          data: this.planData.map(item => ({
            // ECharts甘特图需要[开始时间, 结束时间, 工厂名称]的格式
            value: [new Date(item.startDate), new Date(item.endDate), item.factoryName],
            // 额外信息用于tooltip
            subOrderId: item.subOrderId,
            customerName: item.customerName,
            quantity: item.quantity,
            qualityStandard: item.qualityStandard,
            dailyProgress: item.dailyProgress,
            factoryId: item.factoryId,
            factoryName: item.factoryName
          })),
          encode: {
            x: [0, 1],  // 开始和结束时间映射到x轴
            y: 2        // 工厂名称映射到y轴
          },
          itemStyle: {
            color: '#5470C6'  // 甘特条颜色
          },
          barWidth: 20
        }]
      };
      this.chart.setOption(option);
    }
  },
  beforeDestroy() {
    if (this.chart) {
      this.chart.dispose();
    }
  }
};
</script>

<style scoped>
.gantt-container {
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.1);
}
.loading {
  text-align: center;
  padding: 20px;
  color: #666;
}
</style>