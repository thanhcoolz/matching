import { defineStore } from 'pinia';
import apiClient from '../axios.js';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    isAuthenticated: false,
    user: null
  }),

  actions: {
    async setAuth() {
      this.isAuthenticated = true;
      return true;
    },

    async logout() {
      try {
        // Call logout endpoint to clear HTTP-only cookie
        await apiClient.post('/api/admin/logout');
      } catch (error) {
        console.error('Logout error:', error);
      } finally {
        // Clear local state
        this.isAuthenticated = false;
        this.user = null;
      }
    },

    async checkAuth() {
      try {
        // With HTTP-only cookies, the cookie is automatically sent with the request
        const response = await apiClient.get('/api/admin/admin_sessions/verify_token');
        this.isAuthenticated = response.status === 200;
        return this.isAuthenticated;
      } catch (error) {
        console.error('Auth check failed:', error);
        this.isAuthenticated = false;
        return false;
      }
    }
  }
});

// For backward compatibility
export const useAuth = () => {
  const store = useAuthStore();
  return {
    isAuthenticated: store.isAuthenticated,
    setAuth: store.setAuth,
    clearAuth: store.logout,
    checkAuth: store.checkAuth
  };
};
