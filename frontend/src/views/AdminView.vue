<template>
  <div class="admin-page">
    <div class="card">
      <h2>投票項目管理</h2>

      <div class="add-form">
        <input
          v-model="newItemName"
          placeholder="輸入新投票項目名稱"
          maxlength="100"
          @keyup.enter="addItem"
        />
        <button class="btn btn-primary" @click="addItem" :disabled="!newItemName.trim()">
          新增
        </button>
      </div>

      <table class="item-table">
        <thead>
          <tr>
            <th>編號</th>
            <th>名稱</th>
            <th>目前票數</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in items" :key="item.id">
            <td>{{ item.id }}</td>
            <td>
              <template v-if="editingId === item.id">
                <input
                  v-model="editName"
                  maxlength="100"
                  class="edit-input"
                  @keyup.enter="saveEdit(item.id)"
                />
              </template>
              <template v-else>
                {{ item.name }}
              </template>
            </td>
            <td>{{ item.voteCount }}</td>
            <td class="action-cell">
              <template v-if="editingId === item.id">
                <button class="btn btn-sm btn-primary" @click="saveEdit(item.id)">儲存</button>
                <button class="btn btn-sm btn-secondary" @click="cancelEdit">取消</button>
              </template>
              <template v-else>
                <button class="btn btn-sm btn-secondary" @click="startEdit(item)">編輯</button>
                <button class="btn btn-sm btn-danger" @click="deleteItem(item.id)">刪除</button>
              </template>
            </td>
          </tr>
          <tr v-if="items.length === 0">
            <td colspan="4" class="empty-row">目前無投票項目</td>
          </tr>
        </tbody>
      </table>
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
const newItemName = ref('')
const editingId = ref(null)
const editName = ref('')
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

async function addItem() {
  const name = newItemName.value.trim()
  if (!name) return
  try {
    await voteApi.createItem(name)
    newItemName.value = ''
    showMessage('新增成功')
    await loadItems()
  } catch (e) {
    showMessage('新增失敗：' + e.message, 'error')
  }
}

function startEdit(item) {
  editingId.value = item.id
  editName.value = item.name
}

function cancelEdit() {
  editingId.value = null
  editName.value = ''
}

async function saveEdit(id) {
  const name = editName.value.trim()
  if (!name) return
  try {
    await voteApi.updateItem(id, name)
    editingId.value = null
    editName.value = ''
    showMessage('更新成功')
    await loadItems()
  } catch (e) {
    showMessage('更新失敗：' + e.message, 'error')
  }
}

async function deleteItem(id) {
  if (!confirm('確定要刪除此投票項目？')) return
  try {
    await voteApi.deleteItem(id)
    showMessage('刪除成功')
    await loadItems()
  } catch (e) {
    showMessage('刪除失敗：' + e.message, 'error')
  }
}

onMounted(loadItems)
</script>

<style scoped>
.admin-page {
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

.add-form {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}

.add-form input {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
}

.add-form input:focus {
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

.item-table tbody tr:hover {
  background: #f5f7fa;
}

.edit-input {
  padding: 4px 8px;
  border: 1px solid #1a73e8;
  border-radius: 4px;
  font-size: 14px;
  width: 100%;
  max-width: 240px;
  outline: none;
}

.action-cell {
  white-space: nowrap;
  display: flex;
  gap: 6px;
}

.empty-row {
  text-align: center;
  color: #999;
  padding: 24px;
}

.btn {
  cursor: pointer;
  border: none;
  border-radius: 6px;
  font-size: 13px;
  padding: 6px 14px;
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

.btn-secondary {
  background: #e8e8e8;
  color: #333;
}

.btn-danger {
  background: #e8453c;
  color: #fff;
}
.btn-sm {
  padding: 4px 10px;
  font-size: 12px;
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
