<template>
  <div class="min-h-screen">
    <!-- Hero Section -->
    <section
      class="min-h-[80vh] flex items-center justify-center bg-gradient-to-r from-indigo-900 via-red-800 to-amber-400 px-8">
      <div class="text-center text-white max-w-3xl mx-auto">
        <h1 class="text-5xl md:text-6xl font-bold mb-6 drop-shadow-lg">Find Your Perfect Billiards Match</h1>
        <p class="text-xl md:text-2xl mb-8 leading-relaxed opacity-90">Connect with nearby players and book local clubs
          instantly</p>
        <div class="flex flex-col md:flex-row gap-4 justify-center">
          <button
            class="px-8 py-4 text-lg rounded-full bg-white text-indigo-900 hover:-translate-y-1 transition-transform duration-300">
            Find Matches
          </button>
          <router-link to="/clubs"
            class="px-8 py-4 text-lg rounded-full border-2 border-white text-white hover:-translate-y-1 transition-transform duration-300">
            Book a Club
          </router-link>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="py-20 px-8 bg-gray-50">
      <h2 class="text-4xl text-center text-indigo-900 mb-12 font-bold">Why Choose Us</h2>
      <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-7xl mx-auto">
        <div v-for="(feature, index) in features" :key="index"
          class="bg-white p-8 rounded-2xl text-center shadow-md hover:-translate-y-2 transition-all duration-300">
          <div class="text-5xl mb-4">{{ feature.icon }}</div>
          <h3 class="text-xl font-semibold text-indigo-900 mb-4">{{ feature.title }}</h3>
          <p class="text-gray-600">{{ feature.description }}</p>
        </div>
      </div>
    </section>

    <!-- How It Works -->
    <section class="py-20 px-8 bg-white">
      <h2 class="text-4xl text-center text-indigo-900 mb-12 font-bold">How It Works</h2>
      <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8 max-w-7xl mx-auto">
        <div v-for="(step, index) in steps" :key="index" class="text-center p-8">
          <div
            class="w-10 h-10 bg-indigo-900 text-white rounded-full flex items-center justify-center mx-auto mb-4 font-bold">
            {{ index + 1 }}
          </div>
          <h3 class="text-xl font-semibold text-indigo-900 mb-4">{{ step.title }}</h3>
          <p class="text-gray-600">{{ step.description }}</p>
        </div>
      </div>
    </section>

    <section class="py-20 px-8 bg-gradient-to-r from-indigo-900 to-red-800 text-center text-white">
      <div class="max-w-3xl mx-auto">
        <h2 class="text-4xl font-bold mb-4">Ready to Start Playing?</h2>
        <p class="text-xl mb-8 opacity-90">Join thousands of billiards enthusiasts in your area</p>
        <router-link to="/signUp"
          class="px-8 py-4 text-lg rounded-full bg-white text-indigo-900 hover:-translate-y-1 transition-transform duration-300 inline-block">
          Get Started Now
        </router-link>
      </div>
    </section>
  </div>
</template>

<script setup>
const features = [
  {
    icon: '🎱',
    title: 'Find Matches',
    description: 'Connect with players of your skill level and arrange matches instantly'
  },
  {
    icon: '📍',
    title: 'Book Clubs',
    description: 'Reserve tables at premium billiards clubs in your area'
  },
  {
    icon: '👥',
    title: 'Community',
    description: 'Join a thriving community of billiards enthusiasts'
  }
]

const steps = [
  {
    title: 'Create Profile',
    description: 'Sign up and set your skill level, playing style, and preferences'
  },
  {
    title: 'Find Players',
    description: 'Browse through players in your area and send match requests'
  },
  {
    title: 'Book Venue',
    description: 'Choose from our partner clubs and secure your playing time'
  },
  {
    title: 'Play & Enjoy',
    description: 'Meet up, play, and build your billiards network'
  }
]
</script>
