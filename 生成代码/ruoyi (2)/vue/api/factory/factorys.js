import request from '@/utils/request'

// 查询工厂信息列表
export function listFactorys(query) {
  return request({
    url: '/factory/factorys/list',
    method: 'get',
    params: query
  })
}

// 查询工厂信息详细
export function getFactorys(factoryId) {
  return request({
    url: '/factory/factorys/' + factoryId,
    method: 'get'
  })
}

// 新增工厂信息
export function addFactorys(data) {
  return request({
    url: '/factory/factorys',
    method: 'post',
    data: data
  })
}

// 修改工厂信息
export function updateFactorys(data) {
  return request({
    url: '/factory/factorys',
    method: 'put',
    data: data
  })
}

// 删除工厂信息
export function delFactorys(factoryId) {
  return request({
    url: '/factory/factorys/' + factoryId,
    method: 'delete'
  })
}
