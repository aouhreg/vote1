<template>
  <div>
    <el-alert
      v-if="!loggedIn"
      title="投票需要登入"
      type="warning"
      :closable="false"
      show-icon
      style="margin-bottom:16px"
    >
      <template #default>
        請先 <router-link to="/login" style="font-weight:600">登入 / 註冊</router-link> 後即可投票
      </template>
    </el-alert>

    <el-card shadow="always">
      <template #header>
        <div class="card-header">
          <span><el-icon><Histogram /></el-icon> 目前投票統計</span>
          <el-tag v-if="loggedIn" type="success">已登入：{{ username }}</el-tag>
        </div>
      </template>

      <el-table :data="items" stripe style="width:100%" v-loading="loading">
        <el-table-column label="選擇" width="60" v-if="loggedIn">
          <template #default="{ row }">
            <el-checkbox
              :checked="selectedIds.has(row.id)"
              @change="toggleItem(row.id)"
              @click.stop
            />
          </template>
        </el-table-column>
        <el-table-column prop="id" label="編號" width="80" />
        <el-table-column prop="name" label="投票項目" min-width="200" />
        <el-table-column prop="voteCount" label="目前票數" width="120">
          <template #default="{ row }">
            <el-tag type="primary" effect="plain">{{ row.voteCount }}</el-tag>
          </template>
        </el-table-column>
      </el-table>

      <div v-if="loggedIn" class="vote-action">
        <el-button
          type="primary"
          size="large"
          :disabled="selectedIds.size === 0"
          :loading="submitting"
          @click="submitVote"
        >
          提交投票（已選 {{ selectedIds.size }} 項）
        </el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { voteApi } from '../api/index.js'
import { getToken, getUser } from '../utils/auth.js'

const items = ref([])
const loading = ref(false)
const submitting = ref(false)
const selectedIds = ref(new Set())

const loggedIn = computed(() => !!getToken())
const username = computed(() => getUser() || '')

async function loadItems() {
  loading.value = true
  try {
    items.value = await voteApi.getItems()
  } catch (e) {
    ElMessage.error('載入失敗：' + e.message)
  } finally {
    loading.value = false
  }
}

function toggleItem(id) {
  const set = new Set(selectedIds.value)
  set.has(id) ? set.delete(id) : set.add(id)
  selectedIds.value = set
}

async function submitVote() {
  if (selectedIds.value.size === 0) {
    ElMessage.warning('請至少選擇一個投票項目')
    return
  }
  submitting.value = true
  try {
    await voteApi.castVotes(username.value, Array.from(selectedIds.value))
    ElMessage.success('投票成功！')
    selectedIds.value = new Set()
    await loadItems()
  } catch (e) {
    ElMessage.error('投票失敗：' + e.message)
  } finally {
    submitting.value = false
  }
}

onMounted(loadItems)
</script>

<style scoped>
.card-header { display:flex; justify-content:space-between; align-items:center; }
.card-header span { font-size:16px; font-weight:600; }
.vote-action { margin-top:24px; text-align:center; }
</style>
