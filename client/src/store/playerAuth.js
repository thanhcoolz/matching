import { defineStore } from 'pinia'
import { ref } from 'vue'
import apiClient from '../axios';

const isAuthenticated = ref(localStorage.getItem('playerIsAuthenticated') === 'true');
const currentPlayer = ref(JSON.parse(localStorage.getItem('currentPlayer') || 'null'));

export const usePlayerAuthStore = defineStore('playerAuth', () => {
  const loading = ref(false)

  const setAuth = (playerData) => {
    currentPlayer.value = playerData
    isAuthenticated.value = true
    localStorage.setItem('playerIsAuthenticated', 'true')
    localStorage.setItem('currentPlayer', JSON.stringify(playerData))
  }

  const clearAuth = () => {
    currentPlayer.value = null
    isAuthenticated.value = false
    localStorage.setItem('playerIsAuthenticated', 'false')
    localStorage.removeItem('currentPlayer')
  }

  async function login(phoneNumber, password) {
    try {
      const response = await apiClient.post('/api/player/player_sessions', {
        phone_number: phoneNumber,
        password,
      })

      if (response.data.status === 'ok') {
        setAuth(response.data.player)
        return true
      }
      return false
    } catch (err) {
      console.log('login error', err)
      return false
    }
  }

  async function logout() {
    try {
      await apiClient.delete('/api/player/player_sessions')
      clearAuth()
      return true
    } catch (err) {
      console.error('Logout error:', err)
      return false
    }
  }

  async function checkAuth() {
    try {
      const response = await apiClient.get('/api/player/verify_token')
      if (response.data.authenticated) {
        setAuth(response.data.player)
        return true
      }
      clearAuth()
      return false
    } catch (err) {
      clearAuth()
      return false
    }
  }

  return {
    currentPlayer,
    isAuthenticated,
    loading,
    login,
    setAuth,
    logout,
    checkAuth
  }
})
