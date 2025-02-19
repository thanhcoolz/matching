<template>
  <div class="dashboard">
    <!-- Stats Grid -->
    <div class="stats-grid">
      <div class="stat-card" v-for="(value, key) in stats" :key="key">
        <div class="stat-icon">
          {{ getStatIcon(key) }}
        </div>
        <div class="stat-info">
          <h3>{{ formatStatName(key) }}</h3>
          <div class="stat-value" v-animate-number="value">{{ value }}</div>
        </div>
        <div class="stat-trend">
          <span class="trend-icon">↗</span>
          <span class="trend-value">+5%</span>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="management-section">
      <div class="section-header">
        <h2>Quick Actions</h2>
        <p class="section-subtitle">Manage your platform resources</p>
      </div>
      <div class="action-buttons">
        <button
          v-for="action in quickActions"
          :key="action.name"
          @click="navigateTo(action.route)"
          class="action-button"
        >
          <span class="action-icon">{{ action.icon }}</span>
          <span class="action-text">
            <span class="action-title">{{ action.title }}</span>
            <span class="action-description">{{ action.description }}</span>
          </span>
          <span class="action-arrow">→</span>
        </button>
      </div>
    </div>

    <!-- Recent Activity -->
    <div class="recent-activity">
      <div class="section-header">
        <h2>Recent Activity</h2>
        <p class="section-subtitle">Latest actions across the platform</p>
      </div>

      <div v-if="loading" class="loading-state">
        <div class="loading-spinner">⌛</div>
        <p>Loading recent activities...</p>
      </div>

      <div v-else class="activity-list">
        <div
          v-for="activity in recentActivities"
          :key="activity.id"
          class="activity-item"
        >
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
  name: 'AdminDashboard',
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
  animation: fadeIn 0.5s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.stat-card {
  background: white;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  transition: transform 0.3s, box-shadow 0.3s;
  position: relative;
  overflow: hidden;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 12px rgba(0, 0, 0, 0.1);
}

.stat-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #3498db, #2ecc71);
}

.stat-icon {
  font-size: 2rem;
  margin-right: 20px;
  background: #f8f9fa;
  padding: 12px;
  border-radius: 12px;
}

.stat-info {
  flex: 1;
}

.stat-info h3 {
  margin: 0;
  color: #6c757d;
  font-size: 0.9rem;
  font-weight: 500;
}

.stat-value {
  font-size: 1.8rem;
  font-weight: bold;
  color: #2c3e50;
  margin-top: 5px;
}

.stat-trend {
  display: flex;
  align-items: center;
  color: #2ecc71;
  font-size: 0.9rem;
}

.trend-icon {
  margin-right: 4px;
}

/* Quick Actions */
.section-header {
  margin-bottom: 20px;
}

.section-header h2 {
  color: #2c3e50;
  margin: 0;
  font-size: 1.5rem;
}

.section-subtitle {
  color: #6c757d;
  margin: 5px 0 0;
  font-size: 0.9rem;
}

.action-buttons {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
  padding: 0 20px;
}

@media (max-width: 768px) {
  .action-buttons {
    grid-template-columns: 1fr;
    padding: 0 10px;
  }

  .stats-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    padding: 0 10px;
  }

  .stat-card {
    padding: 16px;
  }

  .stat-icon {
    font-size: 1.5rem;
    padding: 8px;
  }

  .stat-value {
    font-size: 1.5rem;
  }

  .activity-item {
    padding: 12px;
  }

  .activity-icon {
    font-size: 1rem;
    padding: 6px;
  }
}

.action-button {
  background: white;
  border: none;
  padding: 16px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: transform 0.3s, box-shadow 0.3s;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  text-align: left;
}

.action-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.action-icon {
  font-size: 1.5rem;
  margin-right: 15px;
  background: #f8f9fa;
  padding: 10px;
  border-radius: 10px;
}

.action-text {
  flex: 1;
}

.action-title {
  display: block;
  color: #2c3e50;
  font-weight: 500;
  margin-bottom: 4px;
}

.action-description {
  display: block;
  color: #6c757d;
  font-size: 0.85rem;
}

.action-arrow {
  color: #3498db;
  font-size: 1.2rem;
  opacity: 0;
  transform: translateX(-10px);
  transition: opacity 0.3s, transform 0.3s;
}

.action-button:hover .action-arrow {
  opacity: 1;
  transform: translateX(0);
}

/* Recent Activity */
.recent-activity {
  background: white;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.loading-state {
  text-align: center;
  padding: 40px;
  color: #6c757d;
}

.loading-spinner {
  font-size: 2rem;
  margin-bottom: 10px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  100% { transform: rotate(360deg); }
}

.activity-list {
  margin-top: 20px;
}

.activity-item {
  display: flex;
  align-items: flex-start;
  padding: 16px;
  border-bottom: 1px solid #f1f1f1;
  transition: background-color 0.3s;
}

.activity-item:hover {
  background-color: #f8f9fa;
}

.activity-icon {
  font-size: 1.2rem;
  margin-right: 15px;
  background: #f8f9fa;
  padding: 8px;
  border-radius: 8px;
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
  color: #2c3e50;
  font-weight: 500;
}

.activity-time {
  color: #6c757d;
  font-size: 0.85rem;
}

.activity-details {
  color: #6c757d;
  font-size: 0.9rem;
  margin-top: 4px;
}
</style>
