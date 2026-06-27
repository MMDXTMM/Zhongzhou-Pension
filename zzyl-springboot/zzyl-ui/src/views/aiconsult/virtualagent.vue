<template>
  <div class="app-container">
    <div class="chat-container">
      <div class="chat-header">
        <i class="el-icon-mike"></i>
        <span>小智健康 - 您的健康顾问</span>
      </div>
      <div class="chat-messages" ref="messageContainer">
        <div class="message ai-message">
          <div class="avatar">AI</div>
          <div class="message-content">
            <p>您好！我是小智健康，您的专属健康顾问。请问有什么可以帮助您的？</p>
          </div>
        </div>
        <div v-for="(msg, index) in messages" :key="index" :class="['message', msg.role === 'user' ? 'user-message' : 'ai-message']">
          <div class="avatar">{{ msg.role === 'user' ? '我' : 'AI' }}</div>
          <div class="message-content">
            <p>{{ msg.content }}</p>
          </div>
        </div>
        <div v-if="loading" class="message ai-message">
          <div class="avatar">AI</div>
          <div class="message-content">
            <p class="typing">正在思考中<span class="dot">.</span><span class="dot">.</span><span class="dot">.</span></p>
          </div>
        </div>
      </div>
      <div class="chat-input">
        <el-input
          v-model="inputMessage"
          placeholder="请输入您的问题..."
          @keyup.enter.native="sendMessage"
          :disabled="loading"
        >
          <el-button slot="append" icon="el-icon-s-promotion" @click="sendMessage" :disabled="loading || !inputMessage.trim()">
            发送
          </el-button>
        </el-input>
      </div>
    </div>
  </div>
</template>

<script>
import { chatWithAI } from '@/api/aiconsult/virtualagent'

export default {
  name: "VirtualAgent",
  data() {
    return {
      inputMessage: '',
      messages: [],
      loading: false
    }
  },
  methods: {
    async sendMessage() {
      if (!this.inputMessage.trim() || this.loading) return
      
      const userMessage = this.inputMessage.trim()
      this.messages.push({ role: 'user', content: userMessage })
      this.inputMessage = ''
      this.loading = true
      
      this.$nextTick(() => {
        this.scrollToBottom()
      })

      const aiMessage = { role: 'ai', content: '' }
      this.messages.push(aiMessage)

      try {
        const response = await chatWithAI(userMessage)
        this.messages[this.messages.length - 1].content = response.data
      } catch (error) {
        this.messages[this.messages.length - 1].content = '抱歉，服务暂时不可用，请稍后重试。'
      } finally {
        this.loading = false
        this.$nextTick(() => {
          this.scrollToBottom()
        })
      }
    },
    scrollToBottom() {
      const container = this.$refs.messageContainer
      if (container) {
        container.scrollTop = container.scrollHeight
      }
    }
  }
}
</script>

<style scoped>
.chat-container {
  max-width: 800px;
  margin: 0 auto;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  height: 600px;
}

.chat-header {
  background-color: #409eff;
  color: white;
  padding: 15px;
  font-size: 16px;
  font-weight: bold;
  text-align: center;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background-color: #f5f7fa;
}

.message {
  display: flex;
  margin-bottom: 20px;
}

.user-message {
  flex-direction: row-reverse;
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: #409eff;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  flex-shrink: 0;
}

.user-message .avatar {
  background-color: #67c23a;
}

.message-content {
  max-width: 70%;
  margin: 0 10px;
  padding: 10px 15px;
  border-radius: 8px;
  background-color: white;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.user-message .message-content {
  background-color: #e1f3d8;
}

.message-content p {
  margin: 0;
  line-height: 1.6;
  word-wrap: break-word;
}

.typing {
  color: #909399;
}

.dot {
  animation: blink 1.4s infinite both;
}

.dot:nth-child(2) {
  animation-delay: 0.2s;
}

.dot:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes blink {
  0%, 80%, 100% {
    opacity: 0;
  }
  40% {
    opacity: 1;
  }
}

.chat-input {
  padding: 15px;
  background-color: white;
  border-top: 1px solid #e4e7ed;
}
</style>
