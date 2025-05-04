import request from '@/utils/request'

// 查询生产日志列表
export function listLog(query) {
  return request({
    url: '/produce/log/list',
    method: 'get',
    params: query
  })
}

// 查询生产日志详细
export function getLog(logId) {
  return request({
    url: '/produce/log/' + logId,
    method: 'get'
  })
}

// 新增生产日志
export function addLog(data) {
  return request({
    url: '/produce/log',
    method: 'post',
    data: data
  })
}

// 修改生产日志
export function updateLog(data) {
  return request({
    url: '/produce/log',
    method: 'put',
    data: data
  })
}

// 删除生产日志
export function delLog(logId) {
  return request({
    url: '/produce/log/' + logId,
    method: 'delete'
  })
}
