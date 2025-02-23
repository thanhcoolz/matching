<template>
  <div class="create-club">
    <h1>Edit Manager</h1>
    <form @submit.prevent="submitForm">
      <div v-if="errors.length" class="error-block">
        <ul>
          <li v-for="error in errors" :key="error">{{ error }}</li>
        </ul>
      </div>

      <div class="form-group">
        <label for="username">Username</label>
        <input v-model="form.username" type="text" id="username" placeholder="Enter username">
      </div>

      <div class="form-group">
        <label for="password">New Password (optional)</label>
        <input v-model="form.password" type="password" id="password" placeholder="Enter new password">
      </div>

      <div class="form-group">
        <label for="passwordConfirmation">Verify New Password</label>
        <input v-model="form.passwordConfirmation" type="password" id="passwordConfirmation"
          placeholder="Confirm new password">
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
  passwordConfirmation: ''
})

const isSubmitting = ref(false)
const errors = ref([])

const fetchManager = async () => {
  try {
    const response = await axios.get(`/api/admin/clubs/${clubId}/managers/${managerId}`)
    form.value = response.data
  } catch (error) {
    console.error('Error fetching manager:', error)
    errors.value = ['Failed to load manager data']
  }
}

const submitForm = async () => {
  isSubmitting.value = true
  errors.value = []

  try {
    const payload = {
      username: form.value.username
    }

    if (form.value.password) {
      payload.password = form.value.password
      payload.password_confirmation = form.value.passwordConfirmation
    }

    await axios.put(`/api/admin/clubs/${clubId}/managers/${managerId}`, { club_manager: payload })
    router.push(`/admin/clubs/${clubId}/managers`)
  } catch (error) {
    if (error.response && error.response.data.errors) {
      errors.value = error.response.data.errors
    } else {
      console.error('Error updating manager:', error)
      errors.value = ['Failed to update manager']
    }
  } finally {
    isSubmitting.value = false
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
