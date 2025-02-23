<template>
  <div class="create-club">
    <h1>Add New Manager</h1>
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
        <label for="password">Password</label>
        <input v-model="form.password" type="password" id="password" placeholder="Enter password">
      </div>

      <div class="form-group">
        <label for="passwordConfirmation">Verify Password</label>
        <input v-model="form.passwordConfirmation" type="password" id="passwordConfirmation"
          placeholder="Confirm password">
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
  passwordConfirmation: ''
})

const isSubmitting = ref(false)
const errors = ref([])

const submitForm = async () => {
  isSubmitting.value = true
  errors.value = []

  try {
    const payload = {
      username: form.value.username,
      password: form.value.password,
      password_confirmation: form.value.passwordConfirmation,
    }

    await axios.post(`/api/admin/clubs/${clubId}/managers`, { club_manager: payload })
    router.push(`/admin/clubs/${clubId}/managers`)
  } catch (error) {
    if (error.response && error.response.data.errors) {
      errors.value = error.response.data.errors
    } else {
      console.error('Error creating manager:', error)
      errors.value = ['Failed to create manager']
    }
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
@import '../../../assets/styles/admins/create-club.css';
</style>
