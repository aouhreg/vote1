<template>
  <div class="vote-page">
    <div class="card">
      <h2>投票區</h2>

      <div class="voter-form">
        <label>投票人：</label>
        <input
          v-model="voter"
          placeholder="請輸入您的名稱"
          maxlength="100"
        />
      </div>

      <table class="item-table">
        <thead>
          <tr>
            <th class="col-select">選擇</th>
            <th>編號</th>
            <th>投票項目</th>
            <th>目前票數</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="item in items"
            :key="item.id"
            :class="{ selected: selectedIds.has(item.id) }"
            @click="toggleItem(item.id)"
          >
            <td class="col-select">
              <input
                type="checkbox"
                :checked="selectedIds.has(item.id)"
                @change="toggleItem(item.id)"
              />
            </td>
            <td>{{ item.id }}</td>
            <td>{{ item.name }}</td>
            <td><span class="vote-badge">{{ item.voteCount }}</span></td>
          </tr>
          <tr v-if="items.length === 0">
            <td colspan="4" class="empty-row">目前無可投票項目</td>
          </tr>
        </tbody>
      </table>

      <div class="vote-action">
        <button
          class="btn btn-primary"
          @click="submitVote"
          :disabled="!voter.trim() || selectedIds.size === 0"
        >
          提交投票 (已選 {{ selectedIds.size }} 項)
        </button>
      </div>
    </div>

    <div v-if="message" class="toast" :class="messageType">
      {{ message }}
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { voteApi } from '../api/index.js'

const items = ref([])
const voter = ref('')
const selectedIds = ref(new Set())
const message = ref('')
const messageType = ref('success')

function showMessage(msg, type = 'success') {
  message.value = msg
  messageType.value = type
  setTimeout(() => { message.value = '' }, 3000)
}

async function loadItems() {
  try {
    items.value = await voteApi.getItems()
  } catch (e) {
    showMessage('載入失敗：' + e.message, 'error')
  }
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
  const name = voter.value.trim()
  if (!name) {
    showMessage('請輸入投票人名稱', 'error')
    return
  }
  if (selectedIds.value.size === 0) {
    showMessage('請至少選擇一個投票項目', 'error')
    return
  }
  try {
    await voteApi.castVotes(name, Array.from(selectedIds.value))
    showMessage('投票成功！')
    selectedIds.value = new Set()
    voter.value = ''
    await loadItems()
  } catch (e) {
    showMessage('投票失敗：' + e.message, 'error')
  }
}

onMounted(loadItems)
</script>

<style scoped>
.vote-page {
  position: relative;
}

.card {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
}

.card h2 {
  margin-bottom: 16px;
  font-size: 18px;
  color: #1a73e8;
}

.voter-form {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
}

.voter-form label {
  font-size: 14px;
  font-weight: 600;
  white-space: nowrap;
}

.voter-form input {
  flex: 1;
  max-width: 300px;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
}

.voter-form input:focus {
  border-color: #1a73e8;
}

.item-table {
  width: 100%;
  border-collapse: collapse;
}

.item-table th,
.item-table td {
  padding: 10px 12px;
  text-align: left;
  border-bottom: 1px solid #f0f0f0;
  font-size: 14px;
}

.item-table th {
  background: #fafafa;
  font-weight: 600;
  color: #555;
}

.col-select {
  width: 48px;
  text-align: center;
}

.item-table tbody tr {
  cursor: pointer;
  transition: background 0.15s;
}

.item-table tbody tr:hover {
  background: #e8f0fe;
}

.item-table tbody tr.selected {
  background: #e8f0fe;
}

.vote-badge {
  display: inline-block;
  background: #1a73e8;
  color: #fff;
  font-size: 12px;
  font-weight: 600;
  padding: 2px 10px;
  border-radius: 10px;
  min-width: 24px;
  text-align: center;
}

.empty-row {
  text-align: center;
  color: #999;
  padding: 24px;
}

.vote-action {
  margin-top: 20px;
  text-align: center;
}

.btn {
  cursor: pointer;
  border: none;
  border-radius: 6px;
  font-size: 15px;
  padding: 10px 28px;
  transition: opacity 0.2s;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn:hover:not(:disabled) {
  opacity: 0.85;
}

.btn-primary {
  background: #1a73e8;
  color: #fff;
}

.toast {
  position: fixed;
  top: 80px;
  right: 24px;
  padding: 10px 20px;
  border-radius: 6px;
  font-size: 14px;
  color: #fff;
  z-index: 1000;
  animation: fadeIn 0.3s;
}

.toast.success {
  background: #52c41a;
}

.toast.error {
  background: #e8453c;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to   { opacity: 1; transform: translateY(0); }
}
</style>
