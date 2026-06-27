import request from '@/utils/request'

export function listLevel(query) {
  return request({
    url: '/level/level/list',
    method: 'get',
    params: query
  })
}

export function getLevel(id) {
  return request({
    url: '/level/level/' + id,
    method: 'get'
  })
}

export function addLevel(data) {
  return request({
    url: '/level/level',
    method: 'post',
    data: data
  })
}

export function updateLevel(data) {
  return request({
    url: '/level/level',
    method: 'put',
    data: data
  })
}

export function delLevel(ids) {
  return request({
    url: '/level/level/' + ids,
    method: 'delete'
  })
}
