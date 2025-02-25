<template>
  <div class="clubs-page">
    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-content">
        <h1 class="hero-title">Our Partner Clubs</h1>
        <p class="hero-subtitle">Discover premium billiards venues in your area</p>
      </div>
    </section>

    <!-- Search and Filter Section -->
    <section class="search-section">
      <div class="search-container">
        <div class="search-box">
          <input type="text" v-model="searchQuery" placeholder="Search clubs by name or location..."
            class="search-input">
          <span class="search-icon">🔍</span>
        </div>
      </div>
    </section>

    <!-- Clubs Grid -->
    <section class="clubs-section">
      <div class="clubs-grid">
        <div v-for="club in clubs" :key="club.id" class="club-card">
          <div class="club-image">
            <img :src="club.image" :alt="club.name" class="w-full h-full object-cover">
            <div class="club-badge">Partner</div>
          </div>
          <div class="club-content">
            <h3 class="club-name">{{ club.name }}</h3>
            <p class="club-address">
              <span class="icon">📍</span>
              {{ club.address }}
            </p>
            <p class="club-description">{{ club.description }}</p>
            <div class="club-footer">
              <button class="view-btn">View Details</button>
              <button class="book-btn">Book Now</button>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const searchQuery = ref('')

// Dummy data for clubs
const clubs = ref([
  {
    id: 1,
    name: 'Elite Billiards Club',
    address: '123 Main Street, District 1',
    description: 'Premium billiards venue with professional tables and elegant atmosphere.',
    image: 'https://placehold.co/600x400'
  },
  {
    id: 2,
    name: 'Champions Pool Hall',
    address: '456 Park Avenue, District 2',
    description: 'Modern facility featuring tournament-grade equipment and training programs.',
    image: 'https://placehold.co/600x400'
  },
  {
    id: 3,
    name: 'Champions Pool Hall',
    address: '456 Park Avenue, District 2',
    description: 'Modern facility featuring tournament-grade equipment and training programs.',
    image: 'https://placehold.co/600x400'
  },
  {
    id: 4,
    name: 'Champions Pool Hall',
    address: '456 Park Avenue, District 2',
    description: 'Modern facility featuring tournament-grade equipment and training programs.',
    image: 'https://placehold.co/600x400'
  },
  {
    id: 5,
    name: 'Champions Pool Hall',
    address: '456 Park Avenue, District 2',
    description: 'Modern facility featuring tournament-grade equipment and training programs.',
    image: 'https://placehold.co/600x400'
  },
  {
    id: 6,
    name: 'Champions Pool Hall',
    address: '456 Park Avenue, District 2',
    description: 'Modern facility featuring tournament-grade equipment and training programs.',
    image: 'https://placehold.co/600x400'
  },
  // Add more dummy clubs as needed
])
</script>

<style scoped>
.clubs-page {
  min-height: 100vh;
  background-color: #f8f9fa;
}

.hero {
  background: linear-gradient(135deg, #1a2a6c, #b21f1f);
  padding: 4rem 2rem;
  text-align: center;
  color: white;
}

.hero-title {
  font-size: 2.5rem;
  font-weight: bold;
  margin-bottom: 1rem;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.hero-subtitle {
  font-size: 1.2rem;
  opacity: 0.9;
}

.search-section {
  background: white;
  padding: 1.5rem;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.search-container {
  max-width: 800px;
  margin: 0 auto;
}

.search-box {
  position: relative;
}

.search-input {
  width: 100%;
  padding: 1rem 1rem 1rem 3rem;
  border: 2px solid #e2e8f0;
  border-radius: 0.5rem;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.search-input:focus {
  outline: none;
  border-color: #1a2a6c;
}

.search-icon {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
}

.clubs-section {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.clubs-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 2rem;
}

.club-card {
  background: white;
  border-radius: 1rem;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s;
}

.club-card:hover {
  transform: translateY(-5px);
}

.club-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.club-badge {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: rgba(26, 42, 108, 0.9);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 2rem;
  font-size: 0.875rem;
}

.club-content {
  padding: 1.5rem;
}

.club-name {
  font-size: 1.25rem;
  font-weight: bold;
  color: #1a2a6c;
  margin-bottom: 0.5rem;
}

.club-address {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #666;
  margin-bottom: 1rem;
  font-size: 0.875rem;
}

.club-description {
  color: #4a5568;
  margin-bottom: 1.5rem;
  line-height: 1.5;
}

.club-footer {
  display: flex;
  gap: 1rem;
}

.view-btn,
.book-btn {
  flex: 1;
  padding: 0.75rem;
  border-radius: 0.5rem;
  font-weight: 500;
  transition: all 0.3s;
}

.view-btn {
  background: #e2e8f0;
  color: #1a2a6c;
}

.book-btn {
  background: #1a2a6c;
  color: white;
}

.view-btn:hover {
  background: #cbd5e0;
}

.book-btn:hover {
  background: #283c8e;
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2rem;
  }

  .clubs-section {
    padding: 1rem;
  }

  .clubs-grid {
    grid-template-columns: 1fr;
  }
}
</style>
