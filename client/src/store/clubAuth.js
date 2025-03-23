import { ref } from 'vue';
import apiClient from '../axios';

const isAuthenticated = ref(localStorage.getItem('clubIsAuthenticated') === 'true');
const currentClub = ref(JSON.parse(localStorage.getItem('currentClub') || 'null'));
const currentClubManager = ref(JSON.parse(localStorage.getItem('currentClubManager') || 'null'));

export const useClubAuth = () => {
  const loading = ref(false)

  const setAuth = (clubData, clubManagerData) => {
    isAuthenticated.value = true
    currentClub.value = clubData
    currentClubManager.value = clubManagerData
    localStorage.setItem('clubIsAuthenticated', 'true')
    localStorage.setItem('currentClub', JSON.stringify(clubData))
    localStorage.setItem('currentClubManager', JSON.stringify(clubManagerData))
  }

  const clearAuth = () => {
    isAuthenticated.value = false
    currentClub.value = null
    currentClubManager.value = null
    localStorage.setItem('clubIsAuthenticated', 'false')
    localStorage.removeItem('currentClub')
    localStorage.removeItem('currentClubManager')
  }

  const checkAuth = async () => {
    try {
      const response = await apiClient.get('/api/club/verify_token')
      if (response.data.authenticated) {
        setAuth(response.data.current_club, response.data.club_manager)
        return true
      }
      clearAuth()
      return false
    } catch (error) {
      clearAuth()
      return false
    }
  }

  return {
    isAuthenticated,
    currentClub,
    currentClubManager,
    loading,
    setAuth,
    clearAuth,
    checkAuth
  }
}
