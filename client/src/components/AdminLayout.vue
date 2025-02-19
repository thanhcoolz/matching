<template>
  <div>
    <h1>Admin Panel</h1>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'AdminLayout',
};
</script>

<style scoped>
h1 {
  text-align: center;
  margin-bottom: 20px;
}
</style>
