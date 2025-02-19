<template>
  <div class="signin-container">
    <h2>Admin Sign In</h2>
    <form @submit.prevent="handleSignIn">
      <input type="email" v-model="email" placeholder="Email" required />
      <input type="password" v-model="password" placeholder="Password" required />
      <button type="submit">Sign In</button>
    </form>
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuth } from '../../store/auth.js';
import apiClient from '../../axios.js';

export default {
  name: 'AdminSignIn',
  setup() {
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

    return {
      email,
      password,
      errorMessage,
      loading,
      handleSignIn
    };
  },
};
</script>

<style scoped>
.signin-container {
  max-width: 300px;
  margin: auto;
  text-align: center;
  position: relative;
  z-index: 10;
}

input {
  display: block;
  width: 100%;
  margin: 10px 0;
  padding: 8px;
}

button {
  width: 100%;
  padding: 10px;
  background-color: #007bff;
  color: white;
  border: none;
  cursor: pointer;
}

.error {
  color: red;
  margin-top: 10px;
}
</style>
