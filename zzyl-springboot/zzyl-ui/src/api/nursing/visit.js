import request from '@/utils/request'

export function listVisit(query) {
  return request({
    url: '/nursing/visit/list',
    method: 'get',
    params: query
  })
}

export function getVisit(id) {
  return request({
    url: '/nursing/visit/' + id,
    method: 'get'
  })
}

export function addVisit(data) {
  return request({
    url: '/nursing/visit',
    method: 'post',
    data: data
  })
}

export function updateVisit(data) {
  return request({
    url: '/nursing/visit',
    method: 'put',
    data: data
  })
}

export function delVisit(ids) {
  return request({
    url: '/nursing/visit/' + ids,
    method: 'delete'
  })
}

export function approveVisit(id) {
  return request({
    url: '/nursing/visit/approve/' + id,
    method: 'put'
  })
}

export function cancelVisit(id) {
  return request({
    url: '/nursing/visit/cancel/' + id,
    method: 'put'
  })
}

export function signInVisit(id) {
  return request({
    url: '/nursing/visit/signIn/' + id,
    method: 'put'
  })
}

export function leaveVisit(id) {
  return request({
    url: '/nursing/visit/leave/' + id,
    method: 'put'
  })
}
