import request from '@/utils/request'

export function listCheckout(query) {
  return request({
    url: '/admission/checkout/list',
    method: 'get',
    params: query
  })
}

export function getCheckout(id) {
  return request({
    url: '/admission/checkout/' + id,
    method: 'get'
  })
}

export function addCheckout(data) {
  return request({
    url: '/admission/checkout',
    method: 'post',
    data: data
  })
}

export function updateCheckout(data) {
  return request({
    url: '/admission/checkout',
    method: 'put',
    data: data
  })
}

export function delCheckout(id) {
  return request({
    url: '/admission/checkout/' + id,
    method: 'delete'
  })
}

export function approveCheckout(data) {
  return request({
    url: '/admission/checkout/approve',
    method: 'put',
    data: data
  })
}

export function completeCheckout(data) {
  return request({
    url: '/admission/checkout/complete',
    method: 'put',
    data: data
  })
}
