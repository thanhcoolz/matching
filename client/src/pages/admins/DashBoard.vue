<template>
  <div class="dashboard">
    <div class="dashboard-content">
      <!-- Welcome Section -->
      <div class="welcome-section">
        <h1>Welcome back, Admin! 👋</h1>
        <p class="welcome-subtitle">Here's what's happening in your platform</p>
      </div>

      <!-- Stats Grid -->
      <div class="stats-container">
        <div class="stats-grid">
          <div class="stat-card" v-for="(value, key) in stats" :key="key" :class="'stat-' + key.toLowerCase()">
            <div class="stat-header">
              <div class="stat-icon">{{ getStatIcon(key) }}</div>
              <div class="stat-trend">
                <span class="trend-icon">↗</span>
                <span class="trend-value">+5%</span>
              </div>
            </div>
            <div class="stat-info">
              <h3>{{ formatStatName(key) }}</h3>
              <div class="stat-value" v-animate-number="value">{{ value }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content Grid -->
      <div class="main-grid">
        <!-- Quick Actions -->
        <div class="quick-actions-section">
          <div class="section-header">
            <div>
              <h2>Quick Actions</h2>
              <p class="section-subtitle">Manage your platform resources</p>
            </div>
          </div>
          <div class="action-buttons">
            <button v-for="action in quickActions" :key="action.name" @click="navigateTo(action.route)"
              class="action-button">
              <div class="action-content">
                <span class="action-icon">{{ action.icon }}</span>
                <span class="action-text">
                  <span class="action-title">{{ action.title }}</span>
                  <span class="action-description">{{ action.description }}</span>
                </span>
              </div>
              <span class="action-arrow">→</span>
            </button>
          </div>
        </div>

        <!-- Recent Activity -->
        <div class="activity-section">
          <div class="section-header">
            <div>
              <h2>Recent Activity</h2>
              <p class="section-subtitle">Latest actions across the platform</p>
            </div>
          </div>

          <div v-if="loading" class="loading-state">
            <div class="loading-spinner">⌛</div>
            <p>Loading recent activities...</p>
          </div>

          <div v-else class="activity-list">
            <div v-for="activity in recentActivities" :key="activity.id" class="activity-item">
              <div class="activity-icon">{{ getActivityIcon(activity.type) }}</div>
              <div class="activity-content">
                <div class="activity-header">
                  <span class="activity-title">{{ activity.description }}</span>
                  <span class="activity-time">{{ formatTime(activity.timestamp) }}</span>
                </div>
                <div class="activity-details" v-if="activity.details">
                  {{ activity.details }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import apiClient from '../../axios.js';

// Custom number animation directive
const vAnimateNumber = {
  mounted(el, binding) {
    const start = 0;
    const end = binding.value;
    const duration = 1000;
    const startTime = performance.now();

    function update(currentTime) {
      const elapsed = currentTime - startTime;
      const progress = Math.min(elapsed / duration, 1);

      const value = Math.floor(start + (end - start) * progress);
      el.textContent = value.toLocaleString();

      if (progress < 1) {
        requestAnimationFrame(update);
      }
    }

    requestAnimationFrame(update);
  }
};

const router = useRouter();
const stats = ref({
  players: 0,
  clubs: 0,
  parties: 0,
  clubManagers: 0
});
const recentActivities = ref([]);
const loading = ref(true);

const quickActions = [
  {
    icon: '👥',
    title: 'Manage Players',
    description: 'View and manage player profiles',
    route: 'players'
  },
  {
    icon: '🏢',
    title: 'Manage Clubs',
    description: 'Oversee club operations',
    route: 'clubs'
  },
  {
    icon: '🎉',
    title: 'Manage Parties',
    description: 'Monitor ongoing parties',
    route: 'parties'
  },
  {
    icon: '👔',
    title: 'Manage Club Managers',
    description: 'Supervise club management',
    route: 'managers'
  }
];

const getStatIcon = (type) => {
  const icons = {
    players: '👥',
    clubs: '🏢',
    parties: '🎉',
    clubManagers: '👔'
  };
  return icons[type] || '📊';
};

const formatStatName = (key) => {
  return key
    .replace(/([A-Z])/g, ' $1')
    .split(' ')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
};

const getActivityIcon = (type) => {
  const icons = {
    create: '➕',
    update: '✏️',
    delete: '🗑️',
    login: '🔑'
  };
  return icons[type] || '📝';
};

const fetchStats = async () => {
  try {
    const response = await apiClient.get('/api/admin/dashboard/stats');
    stats.value = response.data;
  } catch (error) {
    console.error('Failed to fetch stats:', error);
  }
};

const fetchRecentActivities = async () => {
  try {
    const response = await apiClient.get('/api/admin/dashboard/activities');
    recentActivities.value = response.data;
  } catch (error) {
    console.error('Failed to fetch activities:', error);
  } finally {
    loading.value = false;
  }
};

const navigateTo = (section) => {
  router.push(`/admin/${section}`);
};

const formatTime = (timestamp) => {
  const date = new Date(timestamp);
  const now = new Date();
  const diff = now - date;

  // If less than 24 hours, show relative time
  if (diff < 24 * 60 * 60 * 1000) {
    const hours = Math.floor(diff / (60 * 60 * 1000));
    if (hours < 1) {
      const minutes = Math.floor(diff / (60 * 1000));
      return `${minutes} minute${minutes !== 1 ? 's' : ''} ago`;
    }
    return `${hours} hour${hours !== 1 ? 's' : ''} ago`;
  }

  // Otherwise show date
  return date.toLocaleDateString(undefined, {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

onMounted(() => {
  fetchStats();
  fetchRecentActivities();
});
</script>

<style scoped>
@import '../../assets/styles/admins/dashboard.css';
</style>
