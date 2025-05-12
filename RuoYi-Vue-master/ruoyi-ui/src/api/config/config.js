import request from '@/utils/request'

// 查询参数配置列表
export function listConfig(query) {
  return request({
    url: '/config/config/list',
    method: 'get',
    params: query
  })
}

// 查询参数配置详细
export function getConfig(paramName) {
  return request({
    url: '/config/config/' + paramName,
    method: 'get'
  })
}

// 新增参数配置
export function addConfig(data) {
  return request({
    url: '/config/config',
    method: 'post',
    data: data
  })
}

// 修改参数配置
export function updateConfig(data) {
  return request({
    url: '/config/config',
    method: 'put',
    data: data
  })
}

// 删除参数配置
export function delConfig(paramName) {
  return request({
    url: '/config/config/' + paramName,
    method: 'delete'
  })
}
