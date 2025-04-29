<template>
  <div class="max-w-4xl mx-auto p-8 bg-white rounded-xl shadow-lg">
    <h1 class="text-2xl font-bold text-gray-900 mb-6">Club Settings</h1>

    <form @submit.prevent="handleSubmit" class="space-y-6">
      <!-- Error Messages -->
      <div
        v-if="errors.length > 0"
        class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6"
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

      <!-- Main Image Upload -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1"
          >Main Image</label
        >
        <div class="mt-1 flex items-center space-x-4">
          <div class="w-32 h-32 rounded-lg overflow-hidden bg-gray-100">
            <img
              v-if="mainImagePreview || currentClub?.main_image_url"
              :src="mainImagePreview || currentClub?.main_image_url"
              alt="Main Preview"
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
                  d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                />
              </svg>
            </div>
          </div>
          <input
            type="file"
            ref="mainImageInput"
            @change="handleMainImageChange"
            accept="image/*"
            class="hidden"
          />
          <button
            type="button"
            @click="$refs.mainImageInput.click()"
            class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors"
          >
            Change Main Image
          </button>
        </div>
      </div>

      <!-- Sub Images Upload -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1"
          >Sub Images (Up to 5)</label
        >
        <div class="mt-1 space-y-4">
          <div class="flex flex-wrap gap-4">
            <div
              v-for="(preview, index) in subImagePreviews"
              :key="index"
              class="relative w-32 h-32 rounded-lg overflow-hidden bg-gray-100"
            >
              <img
                :src="preview"
                alt="Sub Preview"
                class="w-full h-full object-cover"
              />
              <button
                @click.prevent="removeSubImage(index)"
                class="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
              >
                <svg
                  class="w-4 h-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </div>

            <div
              v-if="subImagePreviews.length < 5"
              class="w-32 h-32 rounded-lg border-2 border-dashed border-gray-300 flex items-center justify-center cursor-pointer hover:border-gray-400"
              @click="$refs.subImagesInput.click()"
            >
              <svg
                class="w-8 h-8 text-gray-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 4v16m8-8H4"
                />
              </svg>
            </div>
          </div>
          <input
            type="file"
            ref="subImagesInput"
            @change="handleSubImagesChange"
            accept="image/*"
            multiple
            class="hidden"
          />
        </div>
      </div>

      <!-- Basic Info -->
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Club Name</label
          >
          <input
            v-model="form.name"
            type="text"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Email Address</label
          >
          <input
            v-model="form.email"
            type="email"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Description</label
          >
          <textarea
            v-model="form.description"
            rows="4"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          ></textarea>
        </div>
      </div>

      <button
        type="submit"
        class="w-full py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors"
        :disabled="isSubmitting"
      >
        {{ isSubmitting ? "Updating..." : "Update Profile" }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useClubAuth } from "../../store/clubAuth";
import apiClient from "../../axios";

const { currentClub } = useClubAuth();
const errors = ref([]);
const isSubmitting = ref(false);
const mainImagePreview = ref(null);
const subImagePreviews = ref([]);

const form = ref({
  name: "",
  email: "",
  description: "",
  main_image: null,
  sub_images: [],
});

const fetchProfile = async () => {
  try {
    const response = await apiClient.get("/api/club/profile");
    const { club } = response.data;

    form.value.name = club.name;
    form.value.email = club.email;
    form.value.description = club.description;

    // Reset image previews
    mainImagePreview.value = null;
    form.value.main_image = null;
    form.value.sub_images = [];
    subImagePreviews.value = [];

    // Update main image preview if exists
    if (club.main_image_url) {
      mainImagePreview.value = club.main_image_url;
    }

    // Update sub images if they exist
    if (club.sub_image_urls && club.sub_image_urls.length > 0) {
      subImagePreviews.value = club.sub_image_urls;
    }
  } catch (error) {
    console.error("Error fetching profile:", error);
    errors.value = ["Failed to load profile data"];
  }
};

onMounted(() => {
  fetchProfile();
});

const handleMainImageChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    form.value.main_image = file;
    mainImagePreview.value = URL.createObjectURL(file);
  }
};

const handleSubImagesChange = (event) => {
  const files = Array.from(event.target.files);
  const remainingSlots = 5 - subImagePreviews.value.length;
  const validFiles = files.slice(0, remainingSlots);

  validFiles.forEach((file) => {
    form.value.sub_images.push(file);
    subImagePreviews.value.push(URL.createObjectURL(file));
  });
};

const removeSubImage = (index) => {
  form.value.sub_images.splice(index, 1);
  subImagePreviews.value.splice(index, 1);
};

const handleSubmit = async () => {
  try {
    isSubmitting.value = true;
    errors.value = [];

    const formData = new FormData();
    Object.keys(form.value).forEach((key) => {
      if (key === "sub_images") {
        form.value.sub_images.forEach((file) => {
          formData.append(`club[sub_images][]`, file);
        });
      } else if (form.value[key] !== null) {
        formData.append(`club[${key}]`, form.value[key]);
      }
    });

    const response = await apiClient.put("/api/club/profile", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    // Update currentClub with the response data
    const { club } = response.data;
    currentClub.value = club;

    alert("Profile updated successfully!");
  } catch (error) {
    console.error("Error updating profile:", error);
    if (error.response?.data?.errors) {
      errors.value = error.response.data.errors;
    } else {
      errors.value = ["An unexpected error occurred"];
    }
  } finally {
    isSubmitting.value = false;
  }
};
</script>
