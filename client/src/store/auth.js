import { ref } from 'vue';

// Initialize from localStorage
const isAuthenticated = ref(localStorage.getItem('isAuthenticated') === 'true');

export const useAuth = () => {
  const setAuth = () => {
    isAuthenticated.value = true;
    localStorage.setItem('isAuthenticated', 'true');
  };

  const clearAuth = () => {
    isAuthenticated.value = false;
    localStorage.setItem('isAuthenticated', 'false');
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
