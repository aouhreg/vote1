const BASE_URL = '/api'

async function request(url, options = {}) {
  const config = {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  }
  const response = await fetch(`${BASE_URL}${url}`, config)
  const data = await response.json()
  if (!data.success) {
    throw new Error(data.message || '請求失敗')
  }
  return data.data
}

export const voteApi = {
  getItems() {
    return request('/items')
  },

  getItem(id) {
    return request(`/items/${id}`)
  },

  createItem(name) {
    return request('/items', {
      method: 'POST',
      body: JSON.stringify({ name }),
    })
  },

  updateItem(id, name) {
    return request(`/items/${id}`, {
      method: 'PUT',
      body: JSON.stringify({ name }),
    })
  },

  deleteItem(id) {
    return request(`/items/${id}`, {
      method: 'DELETE',
    })
  },

  castVotes(voter, itemIds) {
    return request('/votes', {
      method: 'POST',
      body: JSON.stringify({ voter, itemIds }),
    })
  },
}
