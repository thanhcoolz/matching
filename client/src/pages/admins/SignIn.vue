<template>
  <div class="signin-page">
    <div class="signin-container">
      <div class="signin-box">
        <div class="signin-header">
          <div class="logo">🎮</div>
          <h2>Welcome Back</h2>
          <p class="subtitle">Sign in to your admin account</p>
        </div>

        <form @submit.prevent="handleSignIn" class="signin-form">
          <div class="form-group">
            <label for="email">Email</label>
            <div class="input-wrapper">
              <span class="input-icon">📧</span>
              <input
                id="email"
                type="email"
                v-model="email"
                placeholder="Enter your email"
                :disabled="loading"
                required
              />
            </div>
          </div>

          <div class="form-group">
            <label for="password">Password</label>
            <div class="input-wrapper">
              <span class="input-icon">🔒</span>
              <input
                id="password"
                type="password"
                v-model="password"
                placeholder="Enter your password"
                :disabled="loading"
                required
              />
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
    </div>
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
.signin-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
  padding: 20px;
}

.signin-container {
  width: 100%;
  max-width: 400px;
  margin: auto;
}

.signin-box {
  background: white;
  border-radius: 10px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
  padding: 40px;
  animation: fadeIn 0.5s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.signin-header {
  text-align: center;
  margin-bottom: 30px;
}

.logo {
  font-size: 3rem;
  margin-bottom: 20px;
  animation: bounce 1s ease infinite;
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.subtitle {
  color: #666;
  margin-top: 10px;
}

.form-group {
  margin-bottom: 20px;
}

label {
  display: block;
  margin-bottom: 8px;
  color: #2c3e50;
  font-weight: 500;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 12px;
  font-size: 1.2rem;
}

input {
  width: 100%;
  padding: 12px 12px 12px 40px;
  border: 2px solid #e1e1e1;
  border-radius: 6px;
  font-size: 1rem;
  transition: border-color 0.3s, box-shadow 0.3s;
}

input:focus {
  outline: none;
  border-color: #3498db;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
}

.signin-button {
  width: 100%;
  padding: 12px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.1s;
}

.signin-button:hover {
  background-color: #2980b9;
}

.signin-button:active {
  transform: scale(0.98);
}

.signin-button:disabled {
  background-color: #95a5a6;
  cursor: not-allowed;
}

.loading-spinner {
  animation: spin 1s linear infinite;
  display: inline-block;
}

@keyframes spin {
  100% { transform: rotate(360deg); }
}

.error-container {
  margin-top: 20px;
  padding: 12px;
  background-color: #fee;
  border-radius: 6px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.error-icon {
  font-size: 1.2rem;
}

.error-message {
  color: #e74c3c;
  margin: 0;
  font-size: 0.9rem;
}
</style>
