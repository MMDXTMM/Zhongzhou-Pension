import request from '@/utils/request'

export function listPlan(query) {
  return request({
    url: '/plan/plan/list',
    method: 'get',
    params: query
  })
}

export function getPlan(id) {
  return request({
    url: '/plan/plan/' + id,
    method: 'get'
  })
}

export function addPlan(data) {
  return request({
    url: '/plan/plan',
    method: 'post',
    data: data
  })
}

export function updatePlan(data) {
  return request({
    url: '/plan/plan',
    method: 'put',
    data: data
  })
}

export function delPlan(id) {
  return request({
    url: '/plan/plan/' + id,
    method: 'delete'
  })
}
