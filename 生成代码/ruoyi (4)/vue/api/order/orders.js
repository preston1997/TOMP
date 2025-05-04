import request from '@/utils/request'

// 查询订单列表列表
export function listOrders(query) {
  return request({
    url: '/order/orders/list',
    method: 'get',
    params: query
  })
}

// 查询订单列表详细
export function getOrders(orderId) {
  return request({
    url: '/order/orders/' + orderId,
    method: 'get'
  })
}

// 新增订单列表
export function addOrders(data) {
  return request({
    url: '/order/orders',
    method: 'post',
    data: data
  })
}

// 修改订单列表
export function updateOrders(data) {
  return request({
    url: '/order/orders',
    method: 'put',
    data: data
  })
}

// 删除订单列表
export function delOrders(orderId) {
  return request({
    url: '/order/orders/' + orderId,
    method: 'delete'
  })
}
