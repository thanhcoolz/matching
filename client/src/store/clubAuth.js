import { ref } from 'vue';
import apiClient from '../axios';

const isAuthenticated = ref(localStorage.getItem('clubIsAuthenticated') === 'true');
const currentClub = ref(JSON.parse(localStorage.getItem('currentClub') || 'null'));
const currentClubManager = ref(JSON.parse(localStorage.getItem('currentClubManager') || 'null'));

export const useClubAuth = () => {
  const setAuth = (clubData, clubManagerData) => {
    isAuthenticated.value = true;
    currentClub.value = clubData;
    currentClubManager.value = clubManagerData;

    localStorage.setItem('clubIsAuthenticated', 'true');
    localStorage.setItem('currentClub', JSON.stringify(clubData));
    localStorage.setItem('currentClubManager', JSON.stringify(clubManagerData));
  };

  const clearAuth = async () => {
    try {
      await apiClient.delete('/api/club/club_sessions');
    } catch (error) {
      console.error('Error during club sign out:', error);
    } finally {
      // Clear local auth state regardless of API call result
      isAuthenticated.value = false;
      currentClub.value = null;
      currentClubManager.value = null;

      localStorage.setItem('clubIsAuthenticated', 'false');
      localStorage.removeItem('currentClub');
      localStorage.removeItem('currentClubManager');
    }
  };

  const checkAuth = () => {
    const storedAuth = localStorage.getItem('clubIsAuthenticated');
    if (storedAuth !== null) {
      isAuthenticated.value = storedAuth === 'true';
      currentClub.value = JSON.parse(localStorage.getItem('currentClub') || 'null');
      currentClubManager.value = JSON.parse(localStorage.getItem('currentClubManager') || 'null');
    }
    return isAuthenticated.value;
  };

  // Initialize auth state from localStorage
  checkAuth();

  return {
    isAuthenticated,
    currentClub,
    currentClubManager,
    setAuth,
    clearAuth,
    checkAuth
  };
};
