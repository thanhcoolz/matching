<template>
  <div class="layout" style="font-family: 'Poppins', sans-serif;">
    <header class="header">
      <div class="header-content">
        <h1 class="logo">Billiard Matching</h1>
        <nav class="nav">
          <router-link to="/" class="nav-link">Home</router-link>
          <router-link to="/" class="nav-link">Our Partner Clubs</router-link>
          <router-link to="/" class="nav-link">Sign Up</router-link>
        </nav>
      </div>
    </header>

    <main class="main">
      <router-view></router-view>
    </main>

    <footer class="footer">
      <div class="footer-content">
        <p>&copy; 2025 Tan Thanh. All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  background-color: #ffffff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  position: fixed;
  width: 100%;
  top: 0;
  z-index: 1000;
}

.header-content {
  width: 100%;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  font-size: 1.5rem;
  font-weight: bold;
  margin: 0;
}

.nav {
  display: flex;
  gap: 2rem;
}

.nav-link {
  text-decoration: none;
  color: #333;
  font-weight: 500;
  transition: color 0.3s;
}

.nav-link:hover {
  color: #007bff;
}

.main {
  flex: 1;
  margin-top: 4rem;
  width: 100%;
}

.footer {
  background-color: #f8f9fa;
  padding: 1.5rem 0;
  margin-top: auto;
  width: 100%;
}

.footer-content {
  width: 100%;
  padding: 0 2rem;
  text-align: center;
  color: #666;
}

/* Responsive Design */
@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 1rem;
    padding: 1rem;
  }

  .nav {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }

  .main {
    margin-top: 7rem;
  }

  .footer-content {
    padding: 0 1rem;
  }
}
</style>
