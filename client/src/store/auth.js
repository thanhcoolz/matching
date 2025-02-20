import { ref } from 'vue';
import apiClient from '../axios';

// Initialize from localStorage
const isAuthenticated = ref(localStorage.getItem('isAuthenticated') === 'true');

export const useAuth = () => {
  const setAuth = () => {
    isAuthenticated.value = true;
    localStorage.setItem('isAuthenticated', 'true');
  };

  const clearAuth = async () => {
    try {
      await apiClient.delete('/api/admin/admin_sessions');
      isAuthenticated.value = false;
      localStorage.setItem('isAuthenticated', 'false');
    } catch (error) {
      console.error('Error during sign out:', error);
      // Still clear local auth state even if API call fails
      isAuthenticated.value = false;
      localStorage.setItem('isAuthenticated', 'false');
    }
  };

  const checkAuth = () => {
    const storedAuth = localStorage.getItem('isAuthenticated');
    if (storedAuth !== null) {
      isAuthenticated.value = storedAuth === 'true';
    }
    return isAuthenticated.value;
  };

  // Initialize auth state from localStorage
  checkAuth();

  return {
    isAuthenticated,
    setAuth,
    clearAuth,
    checkAuth
  };
};
