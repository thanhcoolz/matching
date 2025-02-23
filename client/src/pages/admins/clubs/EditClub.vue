<template>
  <div class="create-club">
    <h1>Edit Club</h1>
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
        {{ isSubmitting ? 'Updating...' : 'Update Club' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import apiClient from '../../../axios';

const router = useRouter();
const route = useRoute();
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
    const [clubResponse, optionsResponse] = await Promise.all([
      apiClient.get(`/api/admin/clubs/${route.params.id}/edit`),
      apiClient.get('/api/admin/clubs/new')
    ]);

    districts.value = optionsResponse.data.districts;
    streets.value = optionsResponse.data.streets;

    // Populate form with existing club data
    Object.assign(form, clubResponse.data.club);
  } catch (error) {
    console.error('Error fetching data:', error);
    // You might want to show an error message to the user here
  }
};

const handleSubmit = async () => {
  if (isSubmitting.value) return;

  try {
    isSubmitting.value = true;
    await apiClient.put(`/api/admin/clubs/${route.params.id}`, { club: form });
    router.push('/admin/clubs');
  } catch (error) {
    console.error('Error updating club:', error);
    // You might want to show an error message to the user here
  } finally {
    isSubmitting.value = false;
  }
};

// Fetch data when component is mounted
onMounted(fetchData);
</script>

<style scoped>
@import '../../../assets/styles/admins/create-club.css';
</style>
