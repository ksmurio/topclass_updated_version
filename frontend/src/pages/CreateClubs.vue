<template>
  <div class="page-bg">
    <v-container class="page-container">
      <v-row justify="center">
        <v-col cols="12" md="7" lg="5">

          <div class="brand-header mb-6">
            <v-icon color="#1A73E8" size="28">mdi-account-group</v-icon>
            <span class="brand-name">Create Club</span>
          </div>

          <v-card class="register-card">
            <form @submit.prevent="register">
              <v-card-text class="pb-0">
                <h3 class="card-title">New Club</h3>
                <p class="card-subtitle mb-6">Enjoy with your friends</p>

                <v-text-field label="Club Name" v-model="clubname"
                  :rules="[() => !!clubname || 'This field is required']" required variant="outlined"
                  density="comfortable" class="mb-2" />

                <v-select label="Privacy" v-model="isPrivate" :items="[
                  { title: 'Public', value: false },
                  { title: 'Private', value: true }
                ]" required variant="outlined" density="comfortable" class="mb-2" />

                <v-text-field v-if="isPrivate" label="Password" v-model="password"
                  :rules="[() => !!password || 'Password is required for private clubs']" required variant="outlined"
                  density="comfortable" class="mb-2" />

                <v-file-input label="Club Image" v-model="clubimage" accept="image/*" prepend-icon="" variant="outlined"
                  density="comfortable" class="mb-2" />

                <v-text-field label="Description" v-model="description" variant="outlined" density="comfortable"
                  class="mb-2" />

                <v-select label="Club Type" v-model="clubtype" :items="subjects"
                  :rules="[() => !!clubtype || 'This field is required']" required variant="outlined"
                  density="comfortable" />
              </v-card-text>

              <v-card-actions class="d-flex flex-column justify-center pb-6 px-4">
                <v-btn size="large" type="submit" class="submit-btn w-100" variant="flat">
                  Create Club
                </v-btn>
                <p v-if="message" class="mt-3 message-text">{{ message }}</p>
              </v-card-actions>
            </form>
          </v-card>

        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';

const router = useRouter();
const clubname = ref('');
const isPrivate = ref(false);
const password = ref('');
const clubimage = ref(null);
const description = ref('');
const clubtype = ref('');
const message = ref('');
const subjects = ref([]);

const loadSubjects = async () => {
  try {
    const token = localStorage.getItem('token');
    const res = await axios.get('http://localhost:3000/api/auth/getSubjects', { // ← era /subjects
      headers: { 'Authorization': `Bearer ${token}` }
    });
    if (res.data.success) {
      subjects.value = res.data.subjects.map(s => ({ title: s.name, value: s.id }))
      .sort((a, b) => a.title.localeCompare(b.title, 'pt'));
    }
  } catch (error) {
    console.error('Error loading subjects:', error);
  }
};

const register = async () => {
  try {
    const token = localStorage.getItem('token');
    if (!token) { message.value = 'You must be logged in'; return; }
    const formData = new FormData();
    formData.append('clubname', clubname.value);
    formData.append('password', password.value);
    formData.append('description', description.value);
    formData.append('clubtype', clubtype.value);
    formData.append('isPrivate', isPrivate.value);
    if (clubimage.value) { formData.append('image', clubimage.value); }
    const res = await axios.post('http://localhost:3000/api/auth/create_club', formData, {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    if (res.data.success) {
      message.value = 'Club created successfully!';
      setTimeout(() => { router.push('/clubs'); }, 1000);
    }
  } catch (error) {
    message.value = error.response?.data?.message || 'Error connecting to server';
  }
};

onMounted(() => { loadSubjects(); });
</script>

<style scoped>
.page-bg {
  background-color: #f0f2f5;
  min-height: 100vh;
}

.page-container {
  padding-top: 6vh;
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

.register-card {
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
</style>