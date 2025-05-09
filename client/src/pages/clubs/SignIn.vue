<template>
  <div class="bg-gradient-to-r from-blue-50 to-indigo-50">
    <div class="container mx-auto">
      <div class="max-w-md mx-auto bg-white rounded-xl shadow-lg p-8">
        <div>
          <h2 class="text-3xl font-bold text-gray-900 mb-6">
            Sign in to Club Manager
          </h2>
        </div>

        <form class="space-y-6" @submit.prevent="handleSubmit">
          <div class="space-y-4">
            <div class="relative">
              <label
                for="club-search"
                class="block text-sm font-medium text-gray-700 mb-1"
                >Club Name</label
              >
              <input
                id="club-search"
                v-model="clubSearch"
                type="text"
                required
                class="block w-full px-4 py-3 rounded-lg border border-gray-300 shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-200"
                placeholder="Search club name"
                @input="debouncedSearch"
              />
              <div
                v-if="showDropdown && clubs.length > 0"
                class="absolute z-20 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-xl"
              >
                <ul class="max-h-60 overflow-auto py-1">
                  <li
                    v-for="club in clubs"
                    :key="club.id"
                    class="px-4 py-2 hover:bg-indigo-50 cursor-pointer transition-colors duration-150"
                    @click="selectClub(club)"
                  >
                    <div class="flex items-center justify-between">
                      <p>{{ club.name }}</p>
                      <p> - </p>
                      <p>{{ club.email }}</p>
                    </div>
                  </li>
                </ul>
              </div>
            </div>

            <div>
              <label
                for="username"
                class="block text-sm font-medium text-gray-700 mb-1"
                >Username</label
              >
              <input
                id="username"
                v-model="username"
                type="text"
                required
                class="block w-full px-4 py-3 rounded-lg border border-gray-300 shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-200"
                placeholder="Enter your username"
              />
            </div>

            <div>
              <label
                for="password"
                class="block text-sm font-medium text-gray-700 mb-1"
                >Password</label
              >
              <input
                id="password"
                v-model="password"
                type="password"
                required
                class="block w-full px-4 py-3 rounded-lg border border-gray-300 shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-200"
                placeholder="Enter your password"
              />
            </div>
          </div>

          <div
            v-if="errorMessage"
            class="p-3 rounded-lg bg-red-50 border border-red-200 text-red-600 text-sm text-center"
          >
            {{ errorMessage }}
          </div>

          <button
            type="submit"
            class="w-full flex justify-center py-3 px-4 rounded-lg text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200 font-medium"
            :disabled="loading"
          >
            <span v-if="loading" class="flex items-center">
              <svg
                class="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
              >
                <circle
                  class="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  stroke-width="4"
                ></circle>
                <path
                  class="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                ></path>
              </svg>
              Signing in...
            </span>
            <span v-else>Sign in</span>
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useClubAuth } from "../../store/clubAuth";
import apiClient from "../../axios.js";
import debounce from "lodash/debounce";

const router = useRouter();
const { setAuth } = useClubAuth();
const clubSearch = ref("");
const clubs = ref([]);
const showDropdown = ref(false);
const selectedClubId = ref(null);
const username = ref("");
const password = ref("");
const loading = ref(false);
const errorMessage = ref("");

const searchClubs = async (query) => {
  if (!query) {
    clubs.value = [];
    showDropdown.value = false;
    return;
  }

  try {
    const response = await apiClient.get("/api/clubs", {
      params: { name: query },
    });
    clubs.value = response.data;
    showDropdown.value = true;
  } catch (error) {
    console.error("Error searching clubs:", error);
    clubs.value = [];
  }
};

const debouncedSearch = debounce(() => {
  searchClubs(clubSearch.value);
}, 200);

const selectClub = (club) => {
  clubSearch.value = club.name;
  selectedClubId.value = club.id;
  showDropdown.value = false;
};

const handleSubmit = async () => {
  if (!selectedClubId.value) {
    alert("Please select a club");
    return;
  }

  loading.value = true;
  errorMessage.value = "";

  try {
    const response = await apiClient.post("/api/club/club_sessions", {
      club_id: selectedClubId.value,
      username: username.value,
      password: password.value,
    });

    if (response.data) {
      setAuth(response.data.current_club, response.data.club_manager);
      router.push("/club/dashboard");
    } else {
      errorMessage.value = "Authentication failed. Please try again.";
    }
  } catch (error) {
    errorMessage.value = error.response?.data?.error || "Sign in failed";
  } finally {
    loading.value = false;
  }
};

// Close dropdown when clicking outside
onMounted(() => {
  document.addEventListener("click", (e) => {
    if (!e.target.closest("#club-search")) {
      showDropdown.value = false;
    }
  });
});
</script>
