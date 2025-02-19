<template>
  <div class="signin-container">
    <h1 class="signin-title">Admin Panel</h1>
    <form @submit.prevent="handleSignIn" class="signin-form">
      <div class="form-group">
        <label for="email">Email</label>
        <div class="input-wrapper">
          <span class="input-icon">📧</span>
          <input id="email" type="email" v-model="email" placeholder="Enter your email" :disabled="loading" required
            autocomplete="email" />
        </div>
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <div class="input-wrapper">
          <span class="input-icon">🔒</span>
          <input id="password" type="password" v-model="password" placeholder="Enter your password" :disabled="loading"
            required autocomplete="current-password" />
        </div>
      </div>

      <button type="submit" :disabled="loading" class="signin-button">
        <span v-if="loading" class="loading-spinner">⌛</span>
        <span v-else>Sign In</span>
      </button>
    </form>

    <div v-if="errorMessage" class="error-container">
      <span class="error-icon">⚠️</span>
      <p class="error-message">{{ errorMessage }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuth } from '../../store/auth.js';
import apiClient from '../../axios.js';

const router = useRouter();
const { setAuth } = useAuth();
const email = ref('');
const password = ref('');
const errorMessage = ref('');
const loading = ref(false);

const handleSignIn = async () => {
  loading.value = true;
  errorMessage.value = '';

  try {
    const response = await apiClient.post('/api/admin/signin', {
      email: email.value,
      password: password.value,
    });

    if (response.data.message === 'Sign-in successful') {
      setAuth();
      router.push('/admin/dashboard');
    } else {
      errorMessage.value = 'Authentication failed. Please try again.';
    }
  } catch (error) {
    errorMessage.value = error.response?.data?.message || 'Invalid credentials. Please try again.';
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
@import '../../assets/styles/admins/sign-in.css';
</style>
