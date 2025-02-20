<template>
  <div class="admin-auth-layout">
    <!-- Sidebar -->
    <div class="sidebar" :class="{ 'sidebar-collapsed': isSidebarCollapsed }">
      <div class="sidebar-header">
        <h2 class="logo">🎮 Admin</h2>
        <button class="collapse-btn" @click="toggleSidebar">
          {{ isSidebarCollapsed ? '→' : '←' }}
        </button>
      </div>
      <nav class="sidebar-nav">
        <router-link to="/admin/dashboard" class="nav-item">
          <span class="nav-icon">📊</span>
          <span class="nav-text" v-show="!isSidebarCollapsed">Dashboard</span>
        </router-link>
        <router-link to="/admin/players" class="nav-item">
          <span class="nav-icon">👥</span>
          <span class="nav-text" v-show="!isSidebarCollapsed">Players</span>
        </router-link>
        <router-link to="/admin/clubs" class="nav-item">
          <span class="nav-icon">🏢</span>
          <span class="nav-text" v-show="!isSidebarCollapsed">Clubs</span>
        </router-link>
        <router-link to="/admin/parties" class="nav-item">
          <span class="nav-icon">🎉</span>
          <span class="nav-text" v-show="!isSidebarCollapsed">Parties</span>
        </router-link>
        <router-link to="/admin/managers" class="nav-item">
          <span class="nav-icon">👔</span>
          <span class="nav-text" v-show="!isSidebarCollapsed">Managers</span>
        </router-link>
      </nav>
      <div class="sidebar-footer">
        <button class="logout-btn" @click="handleLogout">
          <span class="nav-icon">🚪</span>
          <span class="nav-text" v-show="!isSidebarCollapsed">Logout</span>
        </button>
      </div>
    </div>

    <!-- Main Content -->
    <div class="main-content" :class="{ 'content-expanded': isSidebarCollapsed }">
      <header class="top-header">
        <div class="header-content">
          <h1>{{ currentPageTitle }}</h1>
          <div class="user-menu">
            <span class="user-icon">👤</span>
            <span class="user-name">Admin</span>
          </div>
        </div>
      </header>
      <main class="content-area">
        <router-view></router-view>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuth } from '../store/auth.js';

const route = useRoute();
const router = useRouter();
const { clearAuth } = useAuth();
const isSidebarCollapsed = ref(false);

const currentPageTitle = computed(() => {
  const path = route.path.split('/').pop();
  return path.charAt(0).toUpperCase() + path.slice(1);
});

const toggleSidebar = () => {
  isSidebarCollapsed.value = !isSidebarCollapsed.value;
};

const handleLogout = async () => {
  await clearAuth();
  router.push('/admin/signIn');
};
</script>

<style scoped>
@import '../assets/styles/admins/admin-auth-layout.css';
</style>
