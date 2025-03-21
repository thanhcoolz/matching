import { defineStore } from 'pinia'
import { ref } from 'vue'
import apiClient from '../axios';

const isAuthenticated = ref(localStorage.getItem('playerIsAuthenticated') === 'true');
const currentPlayer = ref(JSON.parse(localStorage.getItem('currentPlayer') || 'null'));

export const usePlayerAuthStore = defineStore('playerAuth', () => {
  const setAuth = (playerData) => {
    currentPlayer.value = playerData
    isAuthenticated.value = true

    localStorage.setItem('playerIsAuthenticated', 'true')
    localStorage.setItem('currentPlayer', JSON.stringify(playerData))
  }

  // Login player
  async function login(phoneNumber, password) {
    try {
      const response = await apiClient.post('/api/player/player_sessions', {
        phone_number: phoneNumber,
        password,
      })

      if (response.data.status === 'ok') {
        setAuth(response.data.player)
        return true;
      }
    } catch (err) {
      console.log('login error', err)
      return false;
    }
  }

  // Register new player
  async function register(playerData) {
    try {
      const response = await apiClient.post('/api/player/register', playerData)
      currentPlayer.value = response.data.player
      isAuthenticated.value = true
    } catch (err) {
      console.log('register error', err)
      return false;
    }
  }

  // Logout player
  async function logout() {
    try {
      await apiClient.post('/api/player/logout')
      currentPlayer.value = null
      isAuthenticated.value = false
    } catch (err) {
      console.error('Logout error:', err)
      return false
    }
  }

  // Check player authentication status
  async function checkAuth() {
    try {
      const response = await apiClient.get('/api/player/check')
      currentPlayer.value = response.data.player
      isAuthenticated.value = true
    } catch (err) {
      currentPlayer.value = null
      isAuthenticated.value = false
    } finally {
      loading.value = false
    }
  }

  return {
    currentPlayer,
    isAuthenticated,
    login,
    setAuth,
    register,
    logout,
    checkAuth
  }
})
