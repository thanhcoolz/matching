<template>
  <div class="signin-page">
    <section class="form-section">
      <div class="form-container">
        <h1 class="form-title">Welcome Back</h1>
        <p class="form-subtitle">Sign in to your account</p>

        <form @submit.prevent="handleSubmit" class="signin-form">
          <!-- Phone Number -->
          <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="tel" id="phone" v-model="formData.phone" class="form-input"
              placeholder="Enter your phone number" required>
          </div>

          <!-- Password -->
          <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" v-model="formData.password" class="form-input"
              placeholder="Enter your password" required>
          </div>

          <button type="submit" class="submit-btn">Sign In</button>
        </form>

        <p class="signup-link">
          Don't have an account?
          <router-link to="/signUp" class="text-blue-600 hover:underline">Sign up</router-link>
        </p>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const formData = ref({
  phone: '',
  password: ''
})

const handleSubmit = async () => {
  try {
    // Add your API call here
    console.log('Form submitted:', formData.value)
    // Redirect to dashboard or home page after successful login
    router.push('/')
  } catch (error) {
    console.error('Login failed:', error)
  }
}
</script>

<style scoped>
.signin-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1a2a6c, #b21f1f);
  padding: 2rem;
}

.form-section {
  max-width: 500px;
  margin: 0 auto;
  padding: 2rem;
}

.form-container {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.form-title {
  font-size: 2rem;
  color: #1a2a6c;
  text-align: center;
  margin-bottom: 0.5rem;
}

.form-subtitle {
  text-align: center;
  color: #666;
  margin-bottom: 2rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #1a2a6c;
  font-weight: 500;
}

.form-input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 0.5rem;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.form-input:focus {
  outline: none;
  border-color: #1a2a6c;
}

.submit-btn {
  width: 100%;
  padding: 1rem;
  background: #1a2a6c;
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-size: 1.1rem;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-btn:hover {
  background: #283c8e;
}

.signup-link {
  text-align: center;
  margin-top: 1.5rem;
  color: #666;
}

@media (max-width: 768px) {
  .form-section {
    padding: 1rem;
  }

  .form-container {
    padding: 1.5rem;
  }

  .form-title {
    font-size: 1.75rem;
  }
}
</style>
