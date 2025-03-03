<template>
  <div class="max-w-2xl mx-auto p-8 bg-white rounded-xl shadow-lg">
    <h1 class="text-2xl font-semibold text-gray-800 mb-8 text-center">Create New Club</h1>

    <!-- Error Messages -->
    <div v-if="errors.length > 0" class="mb-6 bg-red-50 border border-red-200 rounded-lg p-4">
      <h3 class="text-red-800 font-medium mb-2">Please fix the following errors:</h3>
      <ul class="list-disc pl-5 text-red-700">
        <li v-for="(error, index) in errors" :key="index" class="mb-1">{{ error }}</li>
      </ul>
    </div>

    <form @submit.prevent="handleSubmit" class="space-y-6">
      <div class="space-y-1">
        <label for="name" class="block text-sm font-medium text-gray-700">Club Name</label>
        <input type="text" id="name" v-model="form.name" placeholder="Enter club name"
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
      </div>

      <div class="space-y-1">
        <label for="email" class="block text-sm font-medium text-gray-700">Email Address</label>
        <input type="email" id="email" v-model="form.email" placeholder="Enter club email"
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
      </div>

      <div class="space-y-1">
        <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
        <textarea id="description" v-model="form.description" placeholder="Enter club description" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2
          focus:ring-blue-500 focus:border-blue-500 min-h-[120px]"></textarea>
      </div>

      <div class="space-y-1">
        <label for="district" class="block text-sm font-medium text-gray-700">District</label>
        <select id="district" v-model="form.district_id"
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
          <option value="" disabled selected>Select a district</option>
          <option v-for="district in districts" :key="district.id" :value="district.id">
            {{ district.name }}
          </option>
        </select>
      </div>

      <div class="space-y-1" v-if="form.district_id">
        <label for="street" class="block text-sm font-medium text-gray-700">Street</label>
        <select id="street" v-model="form.street_id"
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
          <option value="" disabled selected>Select a street</option>
          <option v-for="street in streets" :key="street.id" :value="street.id">
            {{ street.name }}
          </option>
        </select>
      </div>

      <div class="space-y-1">
        <label for="address" class="block text-sm font-medium text-gray-700">Address</label>
        <input type="text" id="address" v-model="form.address" placeholder="Enter club address"
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
      </div>

      <div class="space-y-1">
        <label class="flex items-center space-x-2">
          <input type="checkbox" v-model="form.active"
            class="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
          <span class="text-sm font-medium text-gray-700">Active</span>
        </label>
      </div>

      <button type="submit"
        class="w-full bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
        :disabled="isSubmitting">
        {{ isSubmitting ? 'Creating...' : 'Create Club' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue';
import { useRouter } from 'vue-router';
import apiClient from '../../../axios';

const router = useRouter();
const districts = ref([]);
const streets = ref([]);
const isSubmitting = ref(false);
const errors = ref([]);

const form = reactive({
  name: '',
  email: '',
  address: '',
  description: '',
  district_id: '',
  street_id: '',
  active: false
});

const fetchData = async () => {
  try {
    const response = await apiClient.get('/api/admin/clubs/new');
    districts.value = response.data.districts;
    streets.value = response.data.streets;
  } catch (error) {
    console.error('Error fetching data:', error);
    errors.value = ['Failed to load form data. Please try again.'];
  }
};

const fetchStreets = async (districtId) => {
  if (!districtId) return;

  try {
    const response = await apiClient.get(`/api/admin/streets?district_id=${districtId}`);
    streets.value = response.data;
  } catch (error) {
    console.error('Error fetching streets:', error);
  }
};

const handleSubmit = async () => {
  if (isSubmitting.value) return;

  try {
    isSubmitting.value = true;
    errors.value = []; // Clear previous errors
    await apiClient.post('/api/admin/clubs', { club: form });
    router.push('/admin/clubs');
  } catch (error) {
    console.error('Error creating club:', error);
    if (error.response && error.response.data && error.response.data.errors) {
      errors.value = error.response.data.errors;
    } else {
      errors.value = ['An unexpected error occurred. Please try again.'];
    }
  } finally {
    isSubmitting.value = false;
  }
};

// Watch for district changes to update streets
watch(() => form.district_id, (newDistrictId) => {
  form.street_id = ''; // Reset street when district changes
  fetchStreets(newDistrictId);
});

// Fetch data when component is mounted
fetchData();
</script>
