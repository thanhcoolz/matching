import { ref } from 'vue';
import apiClient from '../axios';

const isAuthenticated = ref(localStorage.getItem('adminIsAuthenticated') === 'true');
const currentAdmin = ref(JSON.parse(localStorage.getItem('currentAdmin') || 'null'));

export const useAuthStore = () => {
  const setAuth = (adminData) => {
    isAuthenticated.value = true;
    currentAdmin.value = adminData;

    localStorage.setItem('adminIsAuthenticated', 'true');
    localStorage.setItem('currentAdmin', JSON.stringify(adminData));
  };

  const logout = async () => {
    try {
      await apiClient.delete('/api/admin/admin_sessions');
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      isAuthenticated.value = false;
      currentAdmin.value = null;

      localStorage.setItem('adminIsAuthenticated', 'false');
      localStorage.removeItem('currentAdmin');

      window.location.href = '/admin/signIn';
    }
  };

  const checkAuth = async () => {
    try {
      const response = await apiClient.get('/api/admin/verify_token');
      isAuthenticated.value = response.status === 200;
      return isAuthenticated.value;
    } catch (error) {
      console.error('Auth check failed:', error);
      isAuthenticated.value = false;
      return false;
    }
  };

  const login = async (email, password) => {
    try {
      const response = await apiClient.post('/api/admin/admin_sessions', {
        email,
        password
      });

      if (response.data.status === 'ok') {
        setAuth(response.data.admin);
        return true;
      }
      return false;
    } catch (error) {
      console.error('Login error:', error);
      return false;
    }
  };

  // Initialize auth state from localStorage
  const storedAuth = localStorage.getItem('adminIsAuthenticated');
  if (storedAuth !== null) {
    isAuthenticated.value = storedAuth === 'true';
    currentAdmin.value = JSON.parse(localStorage.getItem('currentAdmin') || 'null');
  }

  return {
    isAuthenticated,
    currentAdmin,
    login,
    logout,
    setAuth,
    checkAuth
  };
};

// For backward compatibility
export const useAuth = useAuthStore;
