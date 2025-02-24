<template>
  <div class="min-h-screen bg-gray-100">
    <nav class="bg-white shadow-md">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <div class="flex-shrink-0 flex items-center">
              LOGO
            </div>
          </div>
          <div class="flex items-center">
            <button class="p-2 rounded-md text-gray-600 hover:text-gray-900 focus:outline-none" @click="logout">
              Logout
            </button>
          </div>
        </div>
      </div>
    </nav>

    <main class="py-10">
      <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
        <router-view></router-view>
      </div>
    </main>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useClubAuth } from '../store/clubAuth';

const router = useRouter()
const authStore = useClubAuth()

const logout = async () => {
  try {
    await authStore.clearAuth()
    router.push('/club/signIn')
  } catch (error) {
    console.error('Logout failed:', error)
  }
}
</script>
