<template>
  <div class="login-bg">
    <v-container class="login-container">
      <v-row align="center" justify="center">
        <v-col cols="12" md="5" lg="4">
          <div class="brand-header mb-6">
            <v-icon color="#1A73E8" size="28">mdi-school</v-icon>
            <span class="brand-name">Topclass</span>
          </div>
          <v-card class="login-card">
            <form @submit.prevent="login">
              <v-card-text>
                <h3 class="card-title">Login</h3>
                <p class="card-subtitle mb-6">Believe in your dreams</p>
                <v-text-field label="Email" v-model="email"
                  :rules="[() => !!email || 'This field is required']"
                  required variant="outlined" density="comfortable" class="mb-2" />
                <v-text-field label="Password" v-model="password"
                  :rules="[() => !!password || 'This field is required']"
                  type="password" required variant="outlined" density="comfortable" />
              </v-card-text>
              <v-card-actions class="d-flex flex-column justify-center pb-6 px-4">
                <v-btn size="large" type="submit" class="submit-btn w-100" variant="flat">
                  Login
                </v-btn>
                <p v-if="appStore.message" class="mt-3 message-text">{{ appStore.message }}</p>
                <router-link to="/register" class="login-link mt-3">
                  I don't have an Account
                </router-link>
              </v-card-actions>
            </form>
          </v-card>
        </v-col>
        <v-col cols="12" md="6" class="d-flex justify-center align-center mt-6 mt-md-0">
          <img src="/Images/Login/loginImg.png" class="login-img" />
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script setup>
import { useAppStore } from '../stores/store';
import { useRouter } from 'vue-router';
import { ref, onMounted, onUnmounted } from 'vue';

const appStore = useAppStore()
const router = useRouter()
const email = ref('')
const password = ref('')

const login = async () => {
  appStore.message = '';
  try {
    const success = await appStore.login(email.value, password.value);
    if (success) {
      setTimeout(() => router.push('/home'), 1000);
    }
  } catch (error) {
    if (error.response?.status === 403) {
      const userId = error.response.data.userId;
      router.push({ path: '/confirmar-email', query: { userId } });
    } else {
      console.error('Error connecting to server', error);
    }
  }
}

onMounted(() => { appStore.message = '' })
onUnmounted(() => { appStore.message = '' })
</script>

<style scoped>
.login-bg {
  background-color: #f0f2f5;
  min-height: 100vh;
}

.login-container {
  padding-top: 10vh;
}

.brand-header {
  display: flex;
  align-items: center;
  gap: 8px;
}

.brand-name {
  font-size: 1.3rem;
  font-weight: 700;
  color: #1a1a2e;
  letter-spacing: -0.3px;
}

.login-card {
  border-radius: 16px !important;
  box-shadow: 0 4px 24px rgba(26, 115, 232, 0.08) !important;
  border: 1px solid #e8edf5 !important;
  padding: 8px 16px 0;
}

.card-title {
  font-size: 1.4rem;
  font-weight: 700;
  color: #1a1a2e;
  letter-spacing: -0.3px;
  margin-bottom: 4px;
}

.card-subtitle {
  color: #1A73E8;
  font-size: 0.875rem;
}

:deep(.v-field__outline) {
  opacity: 1;
}

.submit-btn {
  background-color: #1A73E8 !important;
  color: white !important;
  border-radius: 8px !important;
  font-weight: 600;
  font-size: 0.95rem;
  height: 48px !important;
}

.submit-btn:hover {
  background-color: #1558b0 !important;
}

.message-text {
  color: #1A73E8;
  font-size: 0.875rem;
}

.login-link {
  color: #1A73E8;
  text-decoration: none;
  font-size: 0.875rem;
  font-weight: 500;
}

.login-link:hover {
  text-decoration: underline;
}

.login-img {
  max-width: 100%;
  width: 100%;
  height: auto;
  max-height: 70vh;
  object-fit: cover;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(26, 115, 232, 0.12);
}
</style>