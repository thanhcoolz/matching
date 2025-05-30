<template>
  <div class="max-w-2xl mx-auto p-8 bg-white rounded-xl shadow-lg">
    <h1 class="text-2xl font-semibold text-gray-800 mb-8 text-center">Edit Club</h1>
    <form @submit.prevent="handleSubmit" class="space-y-6">
      <div class="space-y-1">
        <label for="name" class="block text-sm font-medium text-gray-700">Club Name</label>
        <input type="text" id="name" v-model="form.name" required placeholder="Enter club name"
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
      </div>

      <div class="space-y-1">
        <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
        <textarea id="description" v-model="form.description" required placeholder="Enter club description"
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 min-h-[120px]"></textarea>
      </div>

      <div class="space-y-1">
        <label for="district" class="block text-sm font-medium text-gray-700">District</label>
        <select id="district" v-model="form.district_id" required
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
          <option value="" disabled selected>Select a district</option>
          <option v-for="district in districts" :key="district.id" :value="district.id">
            {{ district.name }}
          </option>
        </select>
      </div>

      <div class="space-y-1">
        <label for="street" class="block text-sm font-medium text-gray-700">Street</label>
        <select id="street" v-model="form.street_id" required
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
          <option value="" disabled selected>Select a street</option>
          <option v-for=" street in streets" :key="street.id" :value="street.id">
            {{ street.name }}
          </option>
        </select>
      </div>

      <div class=" space-y-1">
        <label for="address" class="block text-sm font-medium text-gray-700">Address</label>
        <input type="text" id="address" v-model="form.address" required placeholder="Enter club address" class=" w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2
          focus:ring-blue-500 focus:border-blue-500">
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
        {{ isSubmitting ? 'Updating...' : 'Update Club' }}
      </button>
    </form>
  </div>
</template>

<script setup>
// Import các hàm và biến cần thiết từ Vue và Vue Router
import { ref, reactive, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import apiClient from '../../../axios';

// Khởi tạo router để điều hướng sau khi cập nhật thành công
const router = useRouter();
// Lấy thông tin route hiện tại để lấy id club cần chỉnh sửa
const route = useRoute();

const districts = ref([]);

const streets = ref([]);
// Biến kiểm soát trạng thái đang gửi form
const isSubmitting = ref(false);

// Đối tượng reactive lưu trữ dữ liệu form chỉnh sửa club
const form = reactive({
  name: '',      
  address: '',      
  description: '',
  district_id: '',  
  street_id: '',  
  active: false     
});

// Hàm lấy dữ liệu club hiện tại và các lựa chọn quận/huyện, đường/phố khi component được mount
const fetchData = async () => {
  try {
    // Gọi song song 2 API: lấy thông tin club và lấy danh sách quận/huyện, đường/phố
    const [clubResponse, optionsResponse] = await Promise.all([
      apiClient.get(`/api/admin/clubs/${route.params.id}/edit`),
      apiClient.get('/api/admin/clubs/new')
    ]);

    // Gán dữ liệu quận/huyện và đường/phố vào biến reactive
    districts.value = optionsResponse.data.districts;
    streets.value = optionsResponse.data.streets;

    // Gán dữ liệu club hiện tại vào form để hiển thị lên giao diện
    Object.assign(form, clubResponse.data.club);
  } catch (error) {
    console.error('Error fetching data:', error);
    // Có thể hiển thị thông báo lỗi cho người dùng tại đây nếu muốn
  }
};

// Hàm xử lý submit form cập nhật club
const handleSubmit = async () => {
  if (isSubmitting.value) return;

  try {
    isSubmitting.value = true;
    // Gửi dữ liệu form lên server để cập nhật club
    await apiClient.put(`/api/admin/clubs/${route.params.id}`, { club: form });
    // Điều hướng về trang danh sách club sau khi cập nhật thành công
    router.push('/admin/clubs');
  } catch (error) {
    console.error('Error updating club:', error);
    // Có thể hiển thị thông báo lỗi cho người dùng tại đây nếu muốn
  } finally {
    isSubmitting.value = false;
  }
};

// Gọi hàm fetchData khi component được mount để lấy dữ liệu ban đầu
onMounted(fetchData);
</script>
