<template>
  <div class="page-bg">
    <v-container class="page-container">
      <v-row justify="center">
        <v-col cols="12" sm="8" md="5" lg="4">

          <div class="brand-header mb-6">
            <v-icon color="#1A73E8" size="28">mdi-school</v-icon>
            <span class="brand-name">Add Grade</span>
          </div>

          <v-card class="register-card">
            <v-card-text>
              <h3 class="card-title">New Grade</h3>
              <p class="card-subtitle mb-6">Register your academic performance</p>

              <v-select label="School Subject" v-model="selectedSubject" :items="subjects"
                item-title="name" item-value="id" required
                variant="outlined" density="comfortable" class="mb-2" />

              <v-select v-if="user && user.school_year < 10" label="Grade" v-model="selectedGrade"
                :items="grade5to9" required variant="outlined" density="comfortable" class="mb-2" />

              <v-select v-else-if="user && user.school_year >= 10" label="Grade" v-model="selectedGrade"
                :items="grade10to12" required variant="outlined" density="comfortable" class="mb-2" />

              <v-btn @click="addGrade" variant="flat" class="submit-btn mt-2" block>
                Add Grade
              </v-btn>

              <v-alert v-if="message" :type="success ? 'success' : 'error'" class="mt-4" variant="tonal" rounded="lg">
                {{ message }}
              </v-alert>
            </v-card-text>
          </v-card>

        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useAppStore } from '@/stores/store.js';
import axios from 'axios';
import { useRouter } from 'vue-router';

const router = useRouter();
const appStore = useAppStore();
const user = appStore.user;
const token = localStorage.getItem('token');
const subjects = ref([]);
const selectedSubject = ref(null);
const selectedGrade = ref(null);
const message = ref('');
const success = ref(null);
const grade5to9 = ['0', '1', '2', '3', '4', '5'];
const grade10to12 = Array.from({ length: 21 }, (_, i) => String(i));

const addGrade = async () => {
    if (!selectedSubject.value || selectedGrade.value === null) {
        success.value = false;
        message.value = 'Please fill all fields';
        return;
    }
    try {
        const response = await axios.post(
            'http://localhost:3000/api/auth/addGrade',
            { subject_id: selectedSubject.value, grade: selectedGrade.value },
            { headers: { Authorization: `Bearer ${token}` } }
        );
        if (response.data.success) {
            success.value = true;
            message.value = 'Grade added successfully!';
            setTimeout(() => router.push('/home'), 1000);
        }
    } catch (error) {
        success.value = false;
        message.value = 'Error adding grade';
    }
};

onMounted(async () => {
    try {
        const response = await axios.get('http://localhost:3000/api/auth/getSubjects', {
            headers: { Authorization: `Bearer ${token}` }
        });
        subjects.value = response.data.subjects.sort((a,b) => a.name.localeCompare(b.name, 'pt'));
    } catch (error) {
        console.log('Error fetching subjects', error);
    }
});
</script>

<style scoped>
.page-bg {
  background-color: #f0f2f5;
  min-height: 100vh;
}

.page-container {
  padding-top: 8vh;
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
  padding: 8px 16px 4px;
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
</style>