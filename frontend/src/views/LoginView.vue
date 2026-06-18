<template>
  <div class="login-wrapper">
    <el-card class="login-card" shadow="always">
      <template #header>
        <el-tabs v-model="activeTab" :stretch="true">
          <el-tab-pane label="登入" name="login" />
          <el-tab-pane label="註冊" name="register" />
        </el-tabs>
      </template>

      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px" @keyup.enter="handleSubmit">
        <el-form-item label="帳號" prop="username">
          <el-input v-model="form.username" placeholder="請輸入帳號" maxlength="50" />
        </el-form-item>
        <el-form-item label="密碼" prop="password">
          <el-input v-model="form.password" type="password" placeholder="請輸入密碼" show-password />
        </el-form-item>
        <el-form-item v-if="activeTab === 'register'" label="確認密碼" prop="confirmPassword">
          <el-input v-model="form.confirmPassword" type="password" placeholder="再次輸入密碼" show-password />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" style="width:100%" @click="handleSubmit">
            {{ loading ? '處理中...' : activeTab === 'login' ? '登入' : '註冊' }}
          </el-button>
        </el-form-item>
      </el-form>

      <div v-if="activeTab === 'login'" style="text-align:center;font-size:13px;color:#999">
        沒有帳號？切換至「註冊」頁籤建立帳號
      </div>
      <div v-else style="text-align:center;font-size:13px;color:#999">
        已有帳號？切換至「登入」頁籤
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { authApi } from '../api/index.js'
import { setToken, setUser, setRole } from '../utils/auth.js'

const router = useRouter()
const route = useRoute()
const formRef = ref(null)
const loading = ref(false)
const activeTab = ref('login')

const form = reactive({ username: '', password: '', confirmPassword: '' })

const rules = {
  username: [
    { required: true, message: '請輸入帳號', trigger: 'blur' },
    { min: 2, max: 50, message: '帳號長度 2~50 字元', trigger: 'blur' },
  ],
  password: [
    { required: true, message: '請輸入密碼', trigger: 'blur' },
    { min: 4, message: '密碼至少 4 個字元', trigger: 'blur' },
  ],
  confirmPassword: [
    { required: true, message: '請再次輸入密碼', trigger: 'blur' },
    {
      validator: (_, value) => value === form.password ? Promise.resolve() : Promise.reject(new Error('兩次密碼不一致')),
      trigger: 'blur',
    },
  ],
}

watch(activeTab, () => { form.confirmPassword = '' })

async function handleSubmit() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  loading.value = true
  try {
    if (activeTab.value === 'login') {
      const data = await authApi.login(form.username, form.password)
      setToken(data.token)
      setUser(data.username)
      setRole(data.role)
      ElMessage.success('登入成功')
      const redirect = route.query.redirect || (data.role === 'ADMIN' ? '/admin' : '/vote')
      router.push(redirect)
    } else {
      await authApi.register(form.username, form.password)
      ElMessage.success('註冊成功，請重新登入')
      activeTab.value = 'login'
      form.password = ''
      form.confirmPassword = ''
    }
  } catch (e) {
    ElMessage.error(e.message || '操作失敗')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-wrapper { display: flex; justify-content: center; align-items: center; min-height: 60vh; }
.login-card { width: 420px; }
</style>
