<template>
  <div class="create-club">
    <h1>Edit Manager</h1>
    <form @submit.prevent="submitForm">
      <div class="form-group">
        <label for="username">Username</label>
        <input v-model="form.username" type="text" id="username" required placeholder="Enter username">
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <input v-model="form.password" type="password" id="password" required placeholder="Enter password">
      </div>

      <button type="submit" class="submit-btn" :disabled="isSubmitting">
        {{ isSubmitting ? 'Updating...' : 'Update Manager' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../../../axios.js'

const route = useRoute()
const router = useRouter()
const clubId = route.params.id
const managerId = route.params.managerId

const form = ref({
  username: '',
  password: '',
})

const fetchManager = async () => {
  try {
    const response = await axios.get(`/api/admin/clubs/${clubId}/managers/${managerId}`)
    form.value = response.data
  } catch (error) {
    console.error('Error fetching manager:', error)
    alert('Failed to load manager data')
  }
}

const submitForm = async () => {
  try {
    await axios.put(`/api/admin/clubs/${clubId}/managers/${managerId}`, form.value)
    router.push(`/admin/clubs/${clubId}/managers`)
  } catch (error) {
    console.error('Error updating manager:', error)
    alert('Failed to update manager')
  }
}

const cancel = () => {
  router.push(`/admin/clubs/${clubId}/managers`)
}

onMounted(() => {
  fetchManager()
})
</script>

<style scoped>
@import '../../../assets/styles/admins/create-club.css';
</style>
