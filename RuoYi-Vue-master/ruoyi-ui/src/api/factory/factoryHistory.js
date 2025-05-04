import request from '@/utils/request'

// 查询工厂变更历史列表
export function listFactoryHistory(query) {
  return request({
    url: '/factory/factoryHistory/list',
    method: 'get',
    params: query
  })
}

// 查询工厂变更历史详细
export function getFactoryHistory(logId) {
  return request({
    url: '/factory/factoryHistory/' + logId,
    method: 'get'
  })
}

// 新增工厂变更历史
export function addFactoryHistory(data) {
  return request({
    url: '/factory/factoryHistory',
    method: 'post',
    data: data
  })
}

// 修改工厂变更历史
export function updateFactoryHistory(data) {
  return request({
    url: '/factory/factoryHistory',
    method: 'put',
    data: data
  })
}

// 删除工厂变更历史
export function delFactoryHistory(logId) {
  return request({
    url: '/factory/factoryHistory/' + logId,
    method: 'delete'
  })
}
