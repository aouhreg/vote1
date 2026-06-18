<template>
  <div>
    <el-card shadow="always">
      <template #header>
        <div class="card-header">
          <span><el-icon><Setting /></el-icon> 投票項目管理</span>
          <el-button type="primary" size="small" @click="openAddDialog">
            <el-icon><Plus /></el-icon> 新增項目
          </el-button>
        </div>
      </template>

      <el-table :data="items" stripe style="width:100%" v-loading="loading">
        <el-table-column prop="id" label="編號" width="80" />
        <el-table-column prop="name" label="名稱" min-width="200" />
        <el-table-column prop="voteCount" label="目前票數" width="120" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="openEditDialog(row)">編輯</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row.id)">刪除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="isEdit ? '編輯投票項目' : '新增投票項目'" width="400px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="名稱" prop="name">
          <el-input v-model="form.name" maxlength="100" placeholder="請輸入投票項目名稱" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">
          {{ saving ? '儲存中...' : '儲存' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { voteApi } from '../api/index.js'

const items = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)
const saving = ref(false)
const editId = ref(null)

const form = ref({ name: '' })
const formRef = ref(null)

const rules = {
  name: [
    { required: true, message: '請輸入名稱', trigger: 'blur' },
    { max: 100, message: '名稱長度不能超過100', trigger: 'blur' },
  ],
}

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

function openAddDialog() {
  isEdit.value = false
  editId.value = null
  form.value = { name: '' }
  dialogVisible.value = true
}

function openEditDialog(row) {
  isEdit.value = true
  editId.value = row.id
  form.value = { name: row.name }
  dialogVisible.value = true
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  saving.value = true
  try {
    if (isEdit.value) {
      await voteApi.updateItem(editId.value, form.value.name)
      ElMessage.success('更新成功')
    } else {
      await voteApi.createItem(form.value.name)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    await loadItems()
  } catch (e) {
    ElMessage.error(e.message)
  } finally {
    saving.value = false
  }
}

async function handleDelete(id) {
  try {
    await ElMessageBox.confirm('確定要刪除此投票項目？相關投票紀錄也將一併刪除。', '確認刪除', {
      confirmButtonText: '確定刪除',
      cancelButtonText: '取消',
      type: 'warning',
    })
    await voteApi.deleteItem(id)
    ElMessage.success('刪除成功')
    await loadItems()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error(e.message || '刪除失敗')
    }
  }
}

onMounted(loadItems)
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.card-header span {
  font-size: 16px;
  font-weight: 600;
}
</style>
