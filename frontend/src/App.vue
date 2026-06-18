<template>
  <el-container>
    <el-header class="app-header">
      <div class="header-inner">
        <router-link to="/vote" class="app-title">線上投票系統</router-link>
        <el-menu mode="horizontal" :ellipsis="false" router class="nav-menu">
          <el-menu-item index="/vote">
            <el-icon><Histogram /></el-icon>
            投票區
          </el-menu-item>
          <el-menu-item index="/admin" v-if="isAdminUser">
            <el-icon><Setting /></el-icon>
            後台管理
          </el-menu-item>
        </el-menu>
        <div class="header-right">
          <template v-if="loggedIn">
            <el-tag :type="userRole === 'ADMIN' ? 'danger' : 'success'" size="small">
              {{ username }} ({{ userRole === 'ADMIN' ? '管理員' : '一般用戶' }})
            </el-tag>
            <el-button size="small" type="danger" plain @click="handleLogout">登出</el-button>
          </template>
          <template v-else>
            <el-button size="small" type="primary" @click="$router.push('/login')">登入 / 註冊</el-button>
          </template>
        </div>
      </div>
    </el-header>
    <el-main class="app-main">
      <router-view />
    </el-main>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { getToken, getUser, getRole, logout as clearAuth, isAdmin } from './utils/auth.js'
import { ElMessage } from 'element-plus'

const router = useRouter()

const loggedIn = computed(() => !!getToken())
const username = computed(() => getUser() || '')
const userRole = computed(() => getRole() || '')
const isAdminUser = computed(() => isAdmin())

function handleLogout() {
  clearAuth()
  ElMessage.success('已登出')
  router.push('/vote')
}
</script>

<style>
body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f5f7fa; }
.app-header { background: #fff; box-shadow: 0 1px 4px rgba(0,0,0,0.08); padding: 0 24px; height: 60px; display: flex; align-items: center; position: sticky; top: 0; z-index: 100; }
.header-inner { width: 100%; max-width: 1100px; margin: 0 auto; display: flex; align-items: center; gap: 24px; }
.app-title { font-size: 20px; font-weight: 700; color: #409eff; text-decoration: none; white-space: nowrap; }
.nav-menu { flex: 1; border-bottom: none !important; }
.header-right { display: flex; align-items: center; gap: 12px; white-space: nowrap; }
.app-main { max-width: 1100px; margin: 24px auto; width: 100%; padding: 0 16px; }
.el-menu--horizontal > .el-menu-item { height: 60px; line-height: 60px; }
</style>
