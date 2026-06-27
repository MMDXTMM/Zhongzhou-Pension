import request from '@/utils/request'

export function listAssessment(query) {
  return request({
    url: '/admission/assessment/list',
    method: 'get',
    params: query
  })
}

export function getAssessment(id) {
  return request({
    url: '/admission/assessment/' + id,
    method: 'get'
  })
}

export function addAssessment(data) {
  return request({
    url: '/admission/assessment',
    method: 'post',
    data: data
  })
}

export function updateAssessment(data) {
  return request({
    url: '/admission/assessment',
    method: 'put',
    data: data
  })
}

export function delAssessment(id) {
  return request({
    url: '/admission/assessment/' + id,
    method: 'delete'
  })
}

export function completeAssessment(id) {
  return request({
    url: '/admission/assessment/complete/' + id,
    method: 'put'
  })
}
