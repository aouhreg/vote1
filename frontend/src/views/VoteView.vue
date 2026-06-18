<template>
  <div>
    <el-card shadow="always">
      <template #header>
        <div class="card-header">
          <span><el-icon><Histogram /></el-icon> 投票區</span>
        </div>
      </template>

      <el-form :model="form" label-width="80px">
        <el-form-item label="投票人">
          <el-input
            v-model="form.voter"
            placeholder="請輸入您的名稱"
            maxlength="100"
            style="max-width:300px"
          />
        </el-form-item>
      </el-form>

      <el-table
        :data="items"
        stripe
        style="width:100%"
        v-loading="loading"
        @row-click="handleRowClick"
      >
        <el-table-column width="60">
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

      <div class="vote-action">
        <el-button
          type="primary"
          size="large"
          :disabled="!form.voter.trim() || selectedIds.size === 0"
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { voteApi } from '../api/index.js'

const items = ref([])
const loading = ref(false)
const submitting = ref(false)
const selectedIds = ref(new Set())

const form = reactive({
  voter: '',
})

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

function handleRowClick(row) {
  toggleItem(row.id)
}

function toggleItem(id) {
  const set = new Set(selectedIds.value)
  if (set.has(id)) {
    set.delete(id)
  } else {
    set.add(id)
  }
  selectedIds.value = set
}

async function submitVote() {
  if (!form.voter.trim()) {
    ElMessage.warning('請輸入投票人名稱')
    return
  }
  if (selectedIds.value.size === 0) {
    ElMessage.warning('請至少選擇一個投票項目')
    return
  }

  submitting.value = true
  try {
    await voteApi.castVotes(form.voter.trim(), Array.from(selectedIds.value))
    ElMessage.success('投票成功！')
    selectedIds.value = new Set()
    form.voter = ''
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
.card-header span {
  font-size: 16px;
  font-weight: 600;
}

.vote-action {
  margin-top: 24px;
  text-align: center;
}
</style>
