import { createApp } from 'vue';
import { createPinia } from 'pinia';
import App from './App.vue';
import router from './router';
import './style.css';

const app = createApp(App);
const pinia = createPinia();

app.use(pinia);
app.use(router);

// Initialize auth check on app start
import { useAuthStore } from './store/auth';
app.config.globalProperties.$auth = useAuthStore();

app.mount('#app');
