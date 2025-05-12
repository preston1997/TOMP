import request from '@/utils/request'

// 查询生产计划列表
export function listPlan(query) {
  return request({
    url: '/produce/plan/list',
    method: 'get',
    params: query
  })
}

// 查询生产计划详细
export function getPlan(planId) {
  return request({
    url: '/produce/plan/' + planId,
    method: 'get'
  })
}

export function getPlanDetail(planId) {
  return request({
    url: '/produce/plan/detail/' + planId,
    method: 'get'
  })
}

// 新增生产计划
export function addPlan(data) {
  return request({
    url: '/produce/plan',
    method: 'post',
    data: data
  })
}

// 修改生产计划
export function updatePlan(data) {
  return request({
    url: '/produce/plan',
    method: 'put',
    data: data
  })
}

// 删除生产计划
export function delPlan(planId) {
  return request({
    url: '/produce/plan/' + planId,
    method: 'delete'
  })
}
