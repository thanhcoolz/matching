<template>
  <div class="admin-layout" :class="{ 'with-sidebar': isAuthenticated }">
    <!-- Sidebar - Only show when authenticated -->
    <div v-if="isAuthenticated" class="sidebar" :class="{ 'sidebar-collapsed': isSidebarCollapsed }">
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

    <!-- Main Content - Full width when not authenticated -->
    <div class="main-content" :class="{
      'content-expanded': isSidebarCollapsed && isAuthenticated,
      'full-width': !isAuthenticated
    }">
      <header v-if="isAuthenticated" class="top-header">
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

<script>
import { ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuth } from '../store/auth.js';

export default {
  setup() {
    const route = useRoute();
    const router = useRouter();
    const auth = useAuth();
    const { isAuthenticated, clearAuth } = auth;
    const isSidebarCollapsed = ref(false);

    const currentPageTitle = computed(() => {
      const path = route.path.split('/').pop();
      return path.charAt(0).toUpperCase() + path.slice(1);
    });

    const toggleSidebar = () => {
      isSidebarCollapsed.value = !isSidebarCollapsed.value;
    };

    const handleLogout = async () => {
      clearAuth();
      router.push('/admin/signin');
    };

    return {
      isAuthenticated,
      isSidebarCollapsed,
      currentPageTitle,
      toggleSidebar,
      handleLogout
    };
  }
};
</script>

<style scoped>
.admin-layout {
  display: flex;
  min-height: 100vh;
  background-color: #f5f7fb;
  width: 100%;
}

.with-sidebar {
  position: relative;
}

.sidebar {
  width: 250px;
  background: #2c3e50;
  color: white;
  transition: width 0.3s ease;
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  z-index: 1000;
}

.sidebar-collapsed {
  width: 60px;
}

.sidebar-header {
  padding: 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.logo {
  margin: 0;
  font-size: 1.2rem;
  white-space: nowrap;
  overflow: hidden;
}

.collapse-btn {
  background: none;
  border: none;
  color: white;
  cursor: pointer;
  padding: 5px;
}

.sidebar-nav {
  flex: 1;
  padding: 20px 0;
  overflow-y: auto;
}

.nav-item {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: white;
  text-decoration: none;
  transition: background-color 0.3s;
  white-space: nowrap;
}

.nav-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.nav-icon {
  margin-right: 15px;
  font-size: 1.2rem;
}

.sidebar-footer {
  padding: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.logout-btn {
  width: 100%;
  padding: 10px;
  background: none;
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
  cursor: pointer;
  display: flex;
  align-items: center;
  transition: background-color 0.3s;
}

.logout-btn:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.main-content {
  flex: 1;
  transition: margin-left 0.3s ease;
  min-width: 0; /* Prevent content from overflowing */
}

.with-sidebar .main-content {
  margin-left: 250px;
}

.with-sidebar .main-content.content-expanded {
  margin-left: 60px;
}

.full-width {
  margin-left: 0;
}

.top-header {
  background: white;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 900;
}

.header-content {
  width: 100%;
  padding: 0 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-content h1 {
  margin: 0;
  font-size: 1.5rem;
  color: #2c3e50;
}

.user-menu {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-icon {
  font-size: 1.2rem;
}

.user-name {
  color: #2c3e50;
}

.content-area {
  width: 100%;
}

/* Router link active state */
.router-link-active {
  background-color: rgba(255, 255, 255, 0.1);
  border-left: 3px solid #3498db;
}

/* Responsive Design */
@media (max-width: 768px) {
  .sidebar {
    transform: translateX(-100%);
    transition: transform 0.3s ease;
  }

  .sidebar-collapsed {
    transform: translateX(-100%);
  }

  .with-sidebar .main-content {
    margin-left: 0;
  }

  .with-sidebar .sidebar {
    transform: translateX(0);
  }

  .with-sidebar .main-content.content-expanded {
    margin-left: 0;
  }

  .header-content {
    padding: 0 10px;
  }

  .user-name {
    display: none;
  }
}
</style>
