<template>
  <div class="create-club">
    <h1>Create New Club</h1>
    <form @submit.prevent="handleSubmit">
      <div class="form-group">
        <label for="name">Club Name</label>
        <input type="text" id="name" v-model="form.name" required placeholder="Enter club name">
      </div>

      <div class="form-group">
        <label for="description">Description</label>
        <textarea id="description" v-model="form.description" required placeholder="Enter club description"></textarea>
      </div>

      <div class="form-group">
        <label for="district">District</label>
        <select id="district" v-model="form.district_id" required>
          <option value="" disabled selected>Select a district</option>
          <option v-for="district in districts" :key="district.id" :value="district.id">
            {{ district.name }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label for="street">Street</label>
        <select id="street" v-model="form.street_id" required>
          <option value="" disabled selected>Select a street</option>
          <option v-for="street in streets" :key="street.id" :value="street.id">
            {{ street.name }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label for="address">Address</label>
        <input type="text" id="address" v-model="form.address" required placeholder="Enter club address">
      </div>

      <button type="submit" class="submit-btn" :disabled="isSubmitting">
        {{ isSubmitting ? 'Creating...' : 'Create Club' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import apiClient from '../../axios';

const router = useRouter();
const districts = ref([]);
const streets = ref([]);
const isSubmitting = ref(false);

const form = reactive({
  name: '',
  address: '',
  description: '',
  district_id: '',
  street_id: ''
});

const fetchData = async () => {
  try {
    const response = await apiClient.get('/api/admin/clubs/new');
    console.log(response.data)
    districts.value = response.data.districts;
    streets.value = response.data.streets;
  } catch (error) {
    console.error('Error fetching data:', error);
    // You might want to show an error message to the user here
  }
};

const handleSubmit = async () => {
  if (isSubmitting.value) return;

  try {
    isSubmitting.value = true;
    await apiClient.post('/api/admin/clubs', { club: form });
    router.push('/admin/dashboard');
  } catch (error) {
    console.error('Error creating club:', error);
    // You might want to show an error message to the user here
  } finally {
    isSubmitting.value = false;
  }
};

// Fetch data when component is mounted
fetchData();
</script>

<style scoped>
@import '../../assets/styles/admins/create-club.css';
</style>
