import { ref } from 'vue';

const isAuthenticated = ref(false);

export const useAuth = () => {
  const setAuth = () => {
    isAuthenticated.value = true;
  };

  const clearAuth = () => {
    isAuthenticated.value = false;
  };

  const checkAuth = () => {
    return isAuthenticated.value;
  };

  return {
    isAuthenticated,
    setAuth,
    clearAuth,
    checkAuth
  };
};
