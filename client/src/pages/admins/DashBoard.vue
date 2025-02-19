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

<script>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import apiClient from '../../axios.js';

// Custom number animation directive
const animateNumber = {
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

export default {
  directives: {
    animateNumber
  },
  setup() {
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

    return {
      stats,
      recentActivities,
      loading,
      quickActions,
      navigateTo,
      formatTime,
      getStatIcon,
      formatStatName,
      getActivityIcon
    };
  }
};
</script>

<style scoped>
.dashboard {
  width: 100%;
  min-height: 100vh;
  background-color: #f8fafc;
}

.dashboard-content {
  padding: 32px;
  animation: fadeIn 0.5s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Welcome Section */
.welcome-section {
  margin-bottom: 32px;
}

.welcome-section h1 {
  font-size: 2rem;
  color: #1e293b;
  margin: 0;
  font-weight: 600;
}

.welcome-subtitle {
  color: #64748b;
  margin: 8px 0 0;
  font-size: 1.1rem;
}

/* Stats Container */
.stats-container {
  margin-bottom: 40px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 24px;
}

.stat-card {
  background: white;
  padding: 24px;
  border-radius: 16px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02);
  transition: transform 0.3s, box-shadow 0.3s;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  border: 1px solid #e2e8f0;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.05);
}

.stat-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
}

.stat-icon {
  font-size: 2.2rem;
  padding: 12px;
  border-radius: 12px;
  background: #f1f5f9;
}

.stat-players .stat-icon {
  background: #e0f2fe;
}

.stat-clubs .stat-icon {
  background: #fef3c7;
}

.stat-parties .stat-icon {
  background: #fce7f3;
}

.stat-clubmanagers .stat-icon {
  background: #dcfce7;
}

.stat-trend {
  display: flex;
  align-items: center;
  font-size: 0.9rem;
  padding: 6px 12px;
  border-radius: 20px;
  background: #f1f5f9;
  color: #059669;
}

.trend-icon {
  margin-right: 4px;
}

.stat-info h3 {
  color: #64748b;
  font-size: 1rem;
  font-weight: 500;
  margin: 0 0 8px 0;
}

.stat-value {
  font-size: 2.2rem;
  font-weight: 600;
  color: #1e293b;
  line-height: 1;
}

/* Main Grid */
.main-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}

/* Quick Actions */
.quick-actions-section {
  background: white;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #e2e8f0;
}

.section-header {
  margin-bottom: 24px;
}

.section-header h2 {
  color: #1e293b;
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
}

.section-subtitle {
  color: #64748b;
  margin: 4px 0 0;
  font-size: 0.95rem;
}

.action-buttons {
  display: grid;
  gap: 16px;
}

.action-button {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  padding: 16px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  transition: all 0.3s ease;
  width: 100%;
}

.action-button:hover {
  background: white;
  border-color: #cbd5e1;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.action-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.action-icon {
  font-size: 1.5rem;
  padding: 12px;
  border-radius: 10px;
  background: white;
}

.action-text {
  display: flex;
  flex-direction: column;
}

.action-title {
  color: #1e293b;
  font-weight: 500;
  font-size: 1.1rem;
}

.action-description {
  color: #64748b;
  font-size: 0.9rem;
  margin-top: 4px;
}

.action-arrow {
  color: #64748b;
  font-size: 1.2rem;
  transition: transform 0.3s;
}

.action-button:hover .action-arrow {
  transform: translateX(4px);
  color: #3b82f6;
}

/* Activity Section */
.activity-section {
  background: white;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02);
  border: 1px solid #e2e8f0;
}

.loading-state {
  text-align: center;
  padding: 40px;
  color: #64748b;
}

.loading-spinner {
  font-size: 2rem;
  margin-bottom: 12px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  100% {
    transform: rotate(360deg);
  }
}

.activity-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.activity-item {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  padding: 16px;
  border-radius: 12px;
  transition: background-color 0.3s;
}

.activity-item:hover {
  background-color: #f8fafc;
}

.activity-icon {
  font-size: 1.2rem;
  padding: 10px;
  border-radius: 10px;
  background: #f1f5f9;
}

.activity-content {
  flex: 1;
}

.activity-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 4px;
}

.activity-title {
  color: #1e293b;
  font-weight: 500;
  font-size: 0.95rem;
}

.activity-time {
  color: #64748b;
  font-size: 0.85rem;
}

.activity-details {
  color: #64748b;
  font-size: 0.9rem;
  margin-top: 4px;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .main-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .dashboard-content {
    padding: 20px;
  }

  .welcome-section h1 {
    font-size: 1.8rem;
  }

  .welcome-subtitle {
    font-size: 1rem;
  }

  .stats-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  }

  .stat-card {
    padding: 20px;
  }

  .stat-icon {
    font-size: 1.8rem;
    padding: 10px;
  }

  .stat-value {
    font-size: 1.8rem;
  }

  .action-button {
    padding: 14px;
  }

  .action-icon {
    padding: 8px;
  }

  .activity-item {
    padding: 12px;
  }
}
</style>
