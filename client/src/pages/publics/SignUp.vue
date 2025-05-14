<template>
  <div
    class="min-h-screen bg-gradient-to-r from-indigo-900 to-red-800 py-8 px-4"
  >
    <div class="max-w-2xl mx-auto px-6">
      <!-- Header -->
      <div class="bg-white rounded-lg shadow-lg p-8 mb-10">
        <h1 class="text-3xl font-bold text-gray-800">Sign Up</h1>
        <p class="text-gray-600 mt-2">Create your account to join games</p>
      </div>

      <!-- Registration Form -->
      <div class="bg-white rounded-lg shadow-lg p-8">
        <!-- Error Messages -->
        <div
          v-if="errors.length > 0"
          class="mb-6 bg-red-50 border border-red-200 rounded-lg p-4"
        >
          <h3 class="text-red-800 font-medium mb-2">
            Please fix the following errors:
          </h3>
          <ul class="list-disc pl-5 text-red-700">
            <li v-for="(error, index) in errors" :key="index" class="mb-1">
              {{ error }}
            </li>
          </ul>
        </div>

        <form @submit.prevent="handleSubmit" class="space-y-6">
          <div class="space-y-4">
            <!-- Avatar Upload -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1"
                >Profile Picture</label
              >
              <div class="mt-1 flex items-center space-x-4">
                <div class="w-24 h-24 rounded-full overflow-hidden bg-gray-100">
                  <img
                    v-if="imagePreview"
                    :src="imagePreview"
                    alt="Preview"
                    class="w-full h-full object-cover"
                  />
                  <div
                    v-else
                    class="w-full h-full flex items-center justify-center text-gray-400"
                  >
                    <svg
                      class="w-12 h-12"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                      />
                    </svg>
                  </div>
                </div>
                <input
                  type="file"
                  ref="fileInput"
                  @change="handleImageChange"
                  accept="image/*"
                  class="hidden"
                />
                <button
                  type="button"
                  @click="$refs.fileInput.click()"
                  class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors"
                >
                  Choose Image
                </button>
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1"
                >Username</label
              >
              <input
                v-model="formData.username"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1"
                >Phone Number</label
              >
              <input
                v-model="formData.phone_number"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1"
                >Age</label
              >
              <select
                v-model="formData.age"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">Select Age</option>
                <option v-for="age in ageOptions" :key="age" :value="age">
                  {{ age }}
                </option>
              </select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1"
                >Gender</label
              >
              <select
                v-model="formData.gender"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">Select Gender</option>
                <option
                  v-for="gender in genderOptions"
                  :key="gender.value"
                  :value="gender.value"
                >
                  {{ gender.label }}
                </option>
              </select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1"
                >Password</label
              >
              <input
                v-model="formData.password"
                type="password"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1"
                >Password Confirmation</label
              >
              <input
                v-model="formData.password_confirmation"
                type="password"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1"
                >District</label
              >
              <select
                v-model="formData.district_id"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">Select District</option>
                <option
                  v-for="district in districts"
                  :key="district.id"
                  :value="district.id"
                >
                  {{ district.name }}
                </option>
              </select>
            </div>

            <div v-if="formData.district_id">
              <label class="block text-sm font-medium text-gray-700 mb-1"
                >Street</label
              >
              <select
                v-model="formData.street_id"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">Select Street</option>
                <option
                  v-for="street in streets"
                  :key="street.id"
                  :value="street.id"
                >
                  {{ street.name }}
                </option>
              </select>
            </div>
          </div>

          <button
            type="submit"
            class="w-full py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors"
          >
            Sign Up
          </button>

          <div class="text-center mt-4">
            <p class="text-gray-600">
              Already have an account?
              <router-link
                to="/signIn"
                class="text-blue-600 hover:text-blue-700"
                >Sign In</router-link
              >
            </p>
          </div>
        </form>
      </div>
    </div>

    <!-- Success Popup -->
    <div
      v-if="showSuccessPopup"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50"
    >
      <div class="bg-white rounded-lg shadow-xl p-8 max-w-md w-full">
        <div class="text-center">
          <div
            class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100 mb-4"
          >
            <svg
              class="h-6 w-6 text-green-600"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M5 13l4 4L19 7"
              />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2">
            Registration Successful!
          </h3>
          <p class="text-gray-600 mb-6">
            Your account has been created successfully. You can now sign in.
          </p>
          <button
            @click="closePopup"
            class="w-full py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors"
          >
            Got it!
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import { useRouter } from "vue-router";
import apiClient from "../../axios";

// Import store quản lý xác thực người chơi
import { usePlayerAuthStore } from "../../store/playerAuth";
const playerStore = usePlayerAuthStore();

const router = useRouter();

const fileInput = ref(null);
// Lưu URL preview ảnh đại diện
const imagePreview = ref(null);

// Danh sách tuổi cho dropdown
const ageOptions = Array.from({ length: 43 }, (_, i) => i + 18);
// Danh sách giới tính cho dropdown
const genderOptions = [
  { value: "male", label: "Male" },
  { value: "female", label: "Female" },
];

const showSuccessPopup = ref(false);

const errors = ref([]);

const districts = ref([]);

const streets = ref([]);

// Đối tượng reactive lưu trữ dữ liệu form đăng ký người chơi
const formData = ref({
  username: "",
  phone_number: "",
  gender: "",
  password: "",
  password_confirmation: "",
  district_id: "",
  street_id: "",
  age: "",
  avatar: null,
});

//Ảnh đại diện được chọn từ phía client và chỉ lưu tạm thời để preview trên giao diện.
//Khi người dùng đăng ký, ảnh sẽ được gửi lên server qua API dưới dạng file (multipart/form-data).
//Server sẽ chịu trách nhiệm lưu trữ file ảnh và trả về đường dẫn ảnh khi cần hiển thị.
//Client không lưu trữ ảnh thực tế, chỉ giữ preview tạm thời cho đến khi gửi form thành công.

// Hàm xử lý khi người dùng chọn ảnh đại diện
const handleImageChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    formData.value.avatar = file;
    imagePreview.value = URL.createObjectURL(file);
  }
};

// Hàm lấy danh sách quận/huyện từ server
const fetchDistricts = async () => {
  try {
    const response = await apiClient.get("/api/public/districts");
    districts.value = response.data;
  } catch (error) {
    console.error("Error fetching districts:", error);
  }
};

// Hàm lấy danh sách đường/phố theo quận/huyện đã chọn
const fetchStreets = async (districtId) => {
  try {
    const response = await apiClient.get(
      "/api/public/streets?district_id=" + districtId
    );
    streets.value = response.data;
  } catch (error) {
    console.error("Error fetching streets:", error);
  }
};

// Theo dõi thay đổi district_id để cập nhật lại danh sách street và reset street_id
watch(
  () => formData.value.district_id,
  () => {
    if (formData.value.district_id) {
      formData.value.street_id = "";
      fetchStreets(formData.value.district_id);
    }
  }
);

// Hàm xử lý submit form đăng ký người chơi
const handleSubmit = async () => {
  try {
    errors.value = []

    // // --- VALIDATION PASSWORD ---
    // const password = formData.value.password
    // const passwordConfirmation = formData.value.password_confirmation

    // if (!password || password.length < 8) {
    //   errors.value.push("Password must be at least 8 characters.")
    // }
    // if (!/[A-Z]/.test(password)) {
    //   errors.value.push("Password must contain at least 1 uppercase letter.")
    // }
    // if (!/[a-z]/.test(password)) {
    //   errors.value.push("Password must contain at least 1 lowercase letter.")
    // }
    // if (!/[0-9]/.test(password)) {
    //   errors.value.push("Password must contain at least 1 number.")
    // }
    // if (!/[^A-Za-z0-9]/.test(password)) {
    //   errors.value.push("Password must contain at least 1 special character.")
    // }
    // if (password !== passwordConfirmation) {
    //   errors.value.push("Confirm password does not match.")
    // }

    // // Nếu có lỗi thì không submit
    // if (errors.value.length > 0) return

    const submitData = new FormData()

    // Duyệt qua từng trường trong formData để append vào FormData gửi lên server
    Object.keys(formData.value).forEach(key => {
      if (formData.value[key] !== '' && formData.value[key] !== null) {
        submitData.append(`player[${key}]`, formData.value[key])
      }
    })

    // Gọi hàm đăng ký trong store (nếu có logic xác thực phía client)
    playerStore.register(submitData);

    // Gửi request đăng ký người chơi lên server (bao gồm cả ảnh đại diện)
    await apiClient.post('/api/public/players/register', submitData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
    showSuccessPopup.value = true
  } catch (error) {
    console.error('Error during sign up:', error)
    if (error.response?.data?.errors) {
      errors.value = error.response.data.errors
    } else {
      errors.value = ['An unexpected error occurred. Please try again.']
    }
  }
}

// Hàm đóng popup thành công và chuyển hướng về trang đăng nhập
const closePopup = () => {
  showSuccessPopup.value = false;
  router.push("/signIn");
};

// Khi component được mount, gọi hàm fetchDistricts để lấy dữ liệu ban đầu
onMounted(() => {
  fetchDistricts();
});
</script>
