<template>
  <div class="create-club">
    <h1>Add New Manager</h1>
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
        {{ isSubmitting ? 'Creating...' : 'Create Manager' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../../../axios.js'

const route = useRoute()
const router = useRouter()
const clubId = route.params.id

const form = ref({
  username: '',
  password: '',
})

const submitForm = async () => {
  try {
    await axios.post(`/api/admin/clubs/${clubId}/managers`, { club_manager: form.value })
    router.push(`/admin/clubs/${clubId}/managers`)
  } catch (error) {
    console.error('Error creating manager:', error)
    alert('Failed to create manager')
  }
}
</script>

<style scoped>
@import '../../../assets/styles/admins/create-club.css';
</style>
