import request from '@/utils/request'

// 查询售后信息列表
export function listAfterSales(query) {
  return request({
    url: '/order/afterSales/list',
    method: 'get',
    params: query
  })
}

// 查询售后信息详细
export function getAfterSales(caseId) {
  return request({
    url: '/order/afterSales/' + caseId,
    method: 'get'
  })
}

// 新增售后信息
export function addAfterSales(data) {
  return request({
    url: '/order/afterSales',
    method: 'post',
    data: data
  })
}

// 修改售后信息
export function updateAfterSales(data) {
  return request({
    url: '/order/afterSales',
    method: 'put',
    data: data
  })
}

// 删除售后信息
export function delAfterSales(caseId) {
  return request({
    url: '/order/afterSales/' + caseId,
    method: 'delete'
  })
}
