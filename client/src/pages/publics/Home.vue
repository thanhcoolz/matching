<template>
  <div class="home">
    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-content">
        <h1 class="hero-title">Find Your Perfect Billiards Match</h1>
        <p class="hero-subtitle">Connect with nearby players and book local clubs instantly</p>
        <div class="hero-buttons">
          <button class="primary-btn">Find Players</button>
          <button class="secondary-btn">Book a Club</button>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="features">
      <h2 class="section-title">Why Choose Us</h2>
      <div class="features-grid">
        <div class="feature-card">
          <div class="feature-icon">🎱</div>
          <h3>Find Matches</h3>
          <p>Connect with players of your skill level and arrange matches instantly</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">📍</div>
          <h3>Book Clubs</h3>
          <p>Reserve tables at premium billiards clubs in your area</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">👥</div>
          <h3>Community</h3>
          <p>Join a thriving community of billiards enthusiasts</p>
        </div>
      </div>
    </section>

    <!-- How It Works -->
    <section class="how-it-works">
      <h2 class="section-title">How It Works</h2>
      <div class="steps">
        <div class="step">
          <div class="step-number">1</div>
          <h3>Create Profile</h3>
          <p>Sign up and set your skill level, playing style, and preferences</p>
        </div>
        <div class="step">
          <div class="step-number">2</div>
          <h3>Find Players</h3>
          <p>Browse through players in your area and send match requests</p>
        </div>
        <div class="step">
          <div class="step-number">3</div>
          <h3>Book Venue</h3>
          <p>Choose from our partner clubs and secure your playing time</p>
        </div>
        <div class="step">
          <div class="step-number">4</div>
          <h3>Play & Enjoy</h3>
          <p>Meet up, play, and build your billiards network</p>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="cta">
      <div class="cta-content">
        <h2>Ready to Start Playing?</h2>
        <p>Join thousands of billiards enthusiasts in your area</p>
        <button class="primary-btn">Get Started Now</button>
      </div>
    </section>
  </div>
</template>

<style scoped>
.home {
  min-height: 100vh;
}

.hero {
  min-height: 80vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
  padding: 2rem;
}

.hero-content {
  text-align: center;
  color: white;
  max-width: 800px;
  margin: 0 auto;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: bold;
  margin-bottom: 1.5rem;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.hero-subtitle {
  font-size: 1.5rem;
  margin-bottom: 2rem;
  line-height: 1.6;
}

.hero-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.primary-btn,
.secondary-btn {
  padding: 1rem 2rem;
  font-size: 1.1rem;
  border-radius: 30px;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.primary-btn {
  background: #ffffff;
  color: #1a2a6c;
  border: none;
}

.secondary-btn {
  background: transparent;
  color: white;
  border: 2px solid white;
}

.primary-btn:hover,
.secondary-btn:hover {
  transform: translateY(-3px);
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2.5rem;
  }

  .hero-subtitle {
    font-size: 1.2rem;
  }

  .hero-buttons {
    flex-direction: column;
  }
}

.features {
  padding: 5rem 2rem;
  background: #f8f9fa;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  color: #1a2a6c;
  margin-bottom: 3rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.feature-card {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-10px);
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.feature-card h3 {
  color: #1a2a6c;
  margin-bottom: 1rem;
}

/* How It Works Section */
.how-it-works {
  padding: 5rem 2rem;
  background: white;
}

.steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.step {
  text-align: center;
  padding: 2rem;
}

.step-number {
  width: 40px;
  height: 40px;
  background: #1a2a6c;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1rem;
  font-weight: bold;
}

/* CTA Section */
.cta {
  background: linear-gradient(135deg, #1a2a6c, #b21f1f);
  padding: 5rem 2rem;
  text-align: center;
  color: white;
}

.cta-content {
  max-width: 800px;
  margin: 0 auto;
}

.cta h2 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.cta p {
  font-size: 1.2rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

/* Responsive adjustments */
@media (max-width: 768px) {

  .features-grid,
  .steps {
    grid-template-columns: 1fr;
  }

  .section-title {
    font-size: 2rem;
  }

  .cta h2 {
    font-size: 2rem;
  }
}
</style>
