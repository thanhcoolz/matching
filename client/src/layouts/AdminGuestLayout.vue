<template>
  <div class="admin-guest-layout">
    <main class="content-area">
      <router-view></router-view>
    </main>
  </div>
</template>

<script>
export default {
  name: 'AdminGuestLayout'
};
</script>

<style scoped>
.admin-guest-layout {
  display: flex;
  min-height: 100vh;
  background-color: #f5f7fb;
  width: 100%;
  overflow-x: hidden;
}

.content-area {
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
  box-sizing: border-box;
}
</style>
