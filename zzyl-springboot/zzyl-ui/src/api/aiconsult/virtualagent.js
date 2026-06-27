import request from '@/utils/request'

export function chatWithAI(prompt) {
  return request({
    url: '/aiconsult/virtualagent/chat',
    method: 'get',
    params: { prompt }
  })
}
