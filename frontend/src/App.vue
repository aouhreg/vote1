<template>
  <div id="app">
    <nav class="nav-bar">
      <div class="nav-inner">
        <h1 class="nav-title">線上投票系統</h1>
        <div class="nav-links">
          <router-link to="/vote">使用者投票</router-link>
          <router-link to="/admin">後台管理</router-link>
        </div>
      </div>
    </nav>
    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<script setup>
</script>

<style>
*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background: #f0f2f5;
  color: #333;
  line-height: 1.6;
}

.nav-bar {
  background: #1a73e8;
  color: #fff;
  padding: 0 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.nav-inner {
  max-width: 960px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  height: 56px;
  gap: 32px;
}

.nav-title {
  font-size: 20px;
  font-weight: 600;
}

.nav-links {
  display: flex;
  gap: 16px;
}

.nav-links a {
  color: #fff;
  text-decoration: none;
  padding: 6px 16px;
  border-radius: 6px;
  font-size: 14px;
  transition: background 0.2s;
}

.nav-links a:hover,
.nav-links a.router-link-exact-active {
  background: rgba(255, 255, 255, 0.2);
}

.main-content {
  max-width: 960px;
  margin: 32px auto;
  padding: 0 24px;
}
</style>
