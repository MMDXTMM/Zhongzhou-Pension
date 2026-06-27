import request from '@/utils/request'

export function listCheckin(query) {
  return request({
    url: '/admission/checkin/list',
    method: 'get',
    params: query
  })
}

export function getCheckedInList() {
  return request({
    url: '/admission/checkin/checkedInList',
    method: 'get'
  })
}

export function getCheckin(id) {
  return request({
    url: '/admission/checkin/' + id,
    method: 'get'
  })
}

export function addCheckin(data) {
  return request({
    url: '/admission/checkin',
    method: 'post',
    data: data
  })
}

export function updateCheckin(data) {
  return request({
    url: '/admission/checkin',
    method: 'put',
    data: data
  })
}

export function delCheckin(id) {
  return request({
    url: '/admission/checkin/' + id,
    method: 'delete'
  })
}

export function confirmCheckin(id) {
  return request({
    url: '/admission/checkin/confirm/' + id,
    method: 'put'
  })
}

export function cancelCheckin(id) {
  return request({
    url: '/admission/checkin/cancel/' + id,
    method: 'put'
  })
}
