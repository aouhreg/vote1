import { createRouter, createWebHistory } from 'vue-router'
import AdminView from '../views/AdminView.vue'
import VoteView from '../views/VoteView.vue'

const routes = [
  { path: '/', redirect: '/vote' },
  { path: '/admin', name: 'Admin', component: AdminView },
  { path: '/vote', name: 'Vote', component: VoteView },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
