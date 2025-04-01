<template>
  <div class="bg-white rounded-xl shadow-md p-6 mb-8">
    <div class="flex justify-between items-center mb-6">
      <div>
        <h2 class="text-xl font-bold text-gray-900">Table Management</h2>
        <p class="text-gray-500 mt-1">
          Update the number of tables in your club
        </p>
      </div>
    </div>

    <form @submit.prevent="updateTableNumbers" class="space-y-4">
      <div>
        <label
          for="tableNumbers"
          class="block text-sm font-medium text-gray-700 mb-1"
          >Number of Tables</label
        >
        <input
          type="number"
          id="tableNumbers"
          v-model.number="tableNumbers"
          min="1"
          required
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all"
        />
      </div>

      <div class="flex justify-end">
        <button
          type="submit"
          :disabled="isSubmitting"
          class="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-2 rounded-lg hover:from-blue-700 hover:to-blue-800 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 shadow-md transition-all duration-300 disabled:opacity-50"
        >
          {{ isSubmitting ? "Updating..." : "Update Tables" }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import axios from "../axios.js";
import { useClubAuth } from "../store/clubAuth";

const { currentClub } = useClubAuth();
const tableNumbers = ref(currentClub.value?.table_numbers || 0);
const isSubmitting = ref(false);

const updateTableNumbers = async () => {
  if (isSubmitting.value) return;

  try {
    isSubmitting.value = true;
    await axios.put(
      `/api/club/managers/${currentClub.value.id}/update_table_numbers`,
      {
        table_numbers: tableNumbers.value,
      }
    );
    alert("Table numbers updated successfully!");
  } catch (error) {
    console.error("Error updating table numbers:", error);
    alert("Failed to update table numbers");
  } finally {
    isSubmitting.value = false;
  }
};
</script>
