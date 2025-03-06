import { defineStore } from 'pinia';
import apiClient from '../axios.js';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    isAuthenticated: false,
    user: null
  }),

  actions: {
    async login(email, password) {
      try {
        const response = await apiClient.post('/api/admin/admin_sessions', {
          email,
          password
        });

        if (response.data.status === 'ok' || response.data.message === 'Sign-in successful') {
          this.isAuthenticated = true;
          return true;
        } else {
          return false;
        }
      } catch (error) {
        console.error('Login error:', error);
        return false;
      }
    },

    async logout() {
      try {
        // Fix: Use the correct endpoint for logout
        await apiClient.delete('/api/admin/admin_sessions');
      } catch (error) {
        console.error('Logout error:', error);
      } finally {
        // Clear local state
        this.isAuthenticated = false;
        this.user = null;

        // Navigate to sign-in page after logout
        window.location.href = '/admin/signIn';
      }
    },

    async checkAuth() {
      try {
        // With HTTP-only cookies, the cookie is automatically sent with the request
        const response = await apiClient.get('/api/admin/verify_token');
        this.isAuthenticated = response.status === 200;
        return this.isAuthenticated;
      } catch (error) {
        console.error('Auth check failed:', error);
        this.isAuthenticated = false;
        return false;
      }
    },

    // Add setAuth method for backward compatibility
    async setAuth() {
      this.isAuthenticated = true;
      return true;
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
