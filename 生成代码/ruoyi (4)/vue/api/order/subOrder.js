import request from '@/utils/request'

// 查询子订单列表列表
export function listSubOrder(query) {
  return request({
    url: '/order/subOrder/list',
    method: 'get',
    params: query
  })
}

// 查询子订单列表详细
export function getSubOrder(subOrderId) {
  return request({
    url: '/order/subOrder/' + subOrderId,
    method: 'get'
  })
}

// 新增子订单列表
export function addSubOrder(data) {
  return request({
    url: '/order/subOrder',
    method: 'post',
    data: data
  })
}

// 修改子订单列表
export function updateSubOrder(data) {
  return request({
    url: '/order/subOrder',
    method: 'put',
    data: data
  })
}

// 删除子订单列表
export function delSubOrder(subOrderId) {
  return request({
    url: '/order/subOrder/' + subOrderId,
    method: 'delete'
  })
}
