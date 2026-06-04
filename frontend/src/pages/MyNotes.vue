<template>
  <div class="page-bg">

    <div class="missions-section">
      <div class="missions-top">
        <div class="missions-label">
          <v-icon size="20" color="#185FA5">mdi-trophy-outline</v-icon>
          <span>Missões da semana</span>
        </div>
        <div class="pts-pill">
          <v-icon size="14" color="#3B6D11">mdi-star</v-icon>
          <span>{{ userPoints }} pts</span>
        </div>
      </div>

      <div v-if="missionsLoading" class="missions-loading">
        <v-progress-circular indeterminate color="#185FA5" size="22" />
        <span>A carregar missões...</span>
      </div>

      <div v-else-if="missions.length === 0" class="missions-empty">
        <v-icon size="32" color="#B5D4F4">mdi-flag-off-outline</v-icon>
        <p>Nenhuma missão esta semana</p>
      </div>

      <div v-else class="missions-grid">
        <div v-for="m in missions" :key="m.id" class="m-card">
          <div class="m-card-header">
            <span class="m-due">
              <v-icon size="13" color="#888">mdi-calendar</v-icon>
              {{ formatDate(m.due_date) }}
            </span>
            <span v-if="m.points" class="m-pts-badge">+{{ m.points }} pts</span>
          </div>
          <p class="m-name">{{ m.name }}</p>
          <p class="m-desc">{{ m.description }}</p>
          <div class="progress-bar-wrap">
            <div class="progress-bar-fill" :style="{ width: (m.progress ?? 0) + '%' }" />
          </div>
          <button class="m-btn" @click="completeMission(m.id)">
            <v-icon size="15" color="#fff">mdi-check-circle-outline</v-icon>
            Completar
          </button>
        </div>
      </div>
    </div>

    <v-container class="page-container" fluid>
      <v-row justify="center">

        <v-col cols="12" sm="6" md="5" lg="4">
          <div class="brand-header mb-6">
            <v-icon color="#1A73E8" size="28">mdi-note-text</v-icon>
            <span class="brand-name">My Notes</span>
          </div>
          <v-card class="register-card">
            <v-card-text>
              <h3 class="card-title">New Note</h3>
              <p class="card-subtitle mb-6">Write and save your thoughts</p>
              <v-text-field v-model="title" label="Title" placeholder="Note title..." variant="outlined" rounded
                class="mb-2" />
              <v-textarea v-model="note" label="Write your note" placeholder="Type something..." variant="outlined"
                rounded rows="4" :counter="200" :maxlength="200" />
              <v-btn variant="flat" class="submit-btn mt-3" block :loading="saving" @click="saveNote">
                <v-icon start>mdi-content-save</v-icon> Save Note
              </v-btn>
            </v-card-text>
          </v-card>
        </v-col>

        <v-col cols="12" sm="6" md="5" lg="4">
          <div class="brand-header mb-6">
            <v-icon color="#1A73E8" size="28">mdi-bookmark-multiple</v-icon>
            <span class="brand-name">Saved Notes</span>
          </div>
          <div v-if="loading" class="text-center mt-8">
            <v-progress-circular indeterminate color="#1A73E8" />
          </div>
          <div v-else-if="notes.length === 0" class="empty-state">
            <v-icon size="48" color="#b0bec5">mdi-note-off-outline</v-icon>
            <p class="mt-3 text-medium-emphasis">No notes saved yet.</p>
          </div>
          <v-card v-for="n in notes" :key="n.id" class="note-card mb-3">
            <v-card-text>
              <div class="note-header">
                <p class="note-title">{{ n.title }}</p>
                <v-btn icon size="small" variant="text" color="success" :loading="deletingId === n.id"
                  @click="completeNote(n.id)">
                  <v-icon size="18">mdi-check-circle-outline</v-icon>
                  <v-tooltip activator="parent" location="top">Mark as done</v-tooltip>
                </v-btn>
              </div>
              <p class="note-content">{{ n.content }}</p>
            </v-card-text>
          </v-card>
        </v-col>

      </v-row>
    </v-container>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const title = ref(''); const note = ref(''); const notes = ref([]);
const saving = ref(false); const loading = ref(false); const deletingId = ref(null);
const missions = ref([]); const missionsLoading = ref(false);
const userPoints = ref(0);

const getToken = () => localStorage.getItem('token');
const formatDate = (d) => d ? new Date(d).toLocaleDateString('pt-PT', { day: '2-digit', month: 'short' }) : '';

const fetchUserPoints = async () => {
  try {
    const res = await fetch('http://localhost:3000/api/auth/user', {
      headers: { Authorization: `Bearer ${getToken()}` },
    });
    const data = await res.json();
    if (data.success) userPoints.value = data.user.points ?? 0;
  } catch (e) { console.error(e); }
};

const fetchMissions = async () => {
  missionsLoading.value = true;
  try {
    const res = await fetch('http://localhost:3000/api/auth/getMissions', {
      headers: { Authorization: `Bearer ${getToken()}` },
    });
    const data = await res.json();
    if (data.success) missions.value = data.missions.filter(m => !m.completed);
  } catch (e) { console.error(e); }
  finally { missionsLoading.value = false; }
};

const fetchNotes = async () => {
  loading.value = true;
  try {
    const res = await fetch('http://localhost:3000/api/auth/getNotes', { headers: { Authorization: `Bearer ${getToken()}` } });
    const data = await res.json();
    if (data.success) notes.value = data.notes;
  } catch (e) { console.error(e); } finally { loading.value = false; }
};

const saveNote = async () => {
  if (!title.value.trim() || !note.value.trim()) return;
  saving.value = true;
  try {
    const res = await fetch('http://localhost:3000/api/auth/saveNotes', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${getToken()}` },
      body: JSON.stringify({ title: title.value, content: note.value }),
    });
    const data = await res.json();
    if (data.success) { notes.value.unshift(data.note); title.value = ''; note.value = ''; }
  } catch (e) { console.error(e); } finally { saving.value = false; }
};

const completeMission = async (id) => {
  try {
    const res = await fetch(`http://localhost:3000/api/auth/completeMission/${id}`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${getToken()}` },
    });
    const data = await res.json();
    if (data.success) {
      missions.value = missions.value.filter(m => m.id !== id);
      userPoints.value += data.points_earned;
    } else {
      alert(data.message);
    }
  } catch (e) { console.error(e); }
};

const completeNote = async (id) => {
  deletingId.value = id;
  try {
    const res = await fetch(`http://localhost:3000/api/auth/notes/${id}`, { method: 'DELETE', headers: { Authorization: `Bearer ${getToken()}` } });
    const data = await res.json();
    if (data.success) notes.value = notes.value.filter(n => n.id !== id);
  } catch (e) { console.error(e); } finally { deletingId.value = null; }
};

onMounted(() => { fetchNotes(); fetchMissions(); fetchUserPoints(); });
</script>

<style scoped>
.page-bg {
  background-color: #f0f2f5;
  min-height: 100vh;
}

.page-container {
  padding-top: 4vh;
}

.missions-section {
  background: #ffffff;
  border-bottom: 1px solid #e8edf5;
  padding: 20px 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.missions-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.missions-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 600;
  color: #1a1a2e;
}

.pts-pill {
  display: flex;
  align-items: center;
  gap: 5px;
  background: #EAF3DE;
  color: #3B6D11;
  font-size: 13px;
  font-weight: 600;
  padding: 5px 13px;
  border-radius: 20px;
  border: 1px solid #C0DD97;
}

.missions-loading,
.missions-empty {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 16px 0;
  color: #90a4ae;
  font-size: 14px;
}

.missions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 12px;
}

.m-card {
  background: #f8faff;
  border: 1px solid #e2ecfb;
  border-radius: 12px;
  padding: 14px 16px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  transition: border-color 0.15s, box-shadow 0.15s;
}

.m-card:hover {
  border-color: #1A73E8;
  box-shadow: 0 4px 16px rgba(26, 115, 232, 0.1);
}

.m-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.m-due {
  font-size: 12px;
  color: #888;
  display: flex;
  align-items: center;
  gap: 4px;
}

.m-pts-badge {
  font-size: 11px;
  font-weight: 600;
  background: #EAF3DE;
  color: #3B6D11;
  border-radius: 4px;
  padding: 2px 7px;
}

.m-name {
  font-size: 14px;
  font-weight: 700;
  color: #1a1a2e;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 0;
}

.m-desc {
  font-size: 13px;
  color: #666;
  line-height: 1.45;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.progress-bar-wrap {
  background: #dde8f8;
  border-radius: 99px;
  height: 4px;
  overflow: hidden;
  margin-top: 2px;
}

.progress-bar-fill {
  height: 100%;
  background: #1A73E8;
  border-radius: 99px;
  transition: width 0.4s ease;
}

.m-btn {
  margin-top: 4px;
  padding: 8px 0;
  font-size: 13px;
  font-weight: 600;
  background: #1A73E8;
  color: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  transition: background 0.15s;
}

.m-btn:hover {
  background: #1558b0;
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
  margin-bottom: 4px;
}

.card-subtitle {
  color: #1A73E8;
  font-size: 0.875rem;
}

.submit-btn {
  background-color: #1A73E8 !important;
  color: white !important;
  border-radius: 8px !important;
  font-weight: 600;
  font-size: 0.95rem;
  height: 48px !important;
}

.note-card {
  border-radius: 12px !important;
  border: 1px solid #e8edf5 !important;
  box-shadow: 0 2px 12px rgba(26, 115, 232, 0.06) !important;
  transition: box-shadow 0.2s;
}

.note-card:hover {
  box-shadow: 0 4px 20px rgba(26, 115, 232, 0.14) !important;
}

.note-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 4px;
}

.note-title {
  font-weight: 700;
  color: #1a1a2e;
  font-size: 1rem;
  margin: 0;
}

.note-content {
  color: #444;
  font-size: 0.95rem;
  white-space: pre-wrap;
  margin-bottom: 8px;
}

.empty-state {
  text-align: center;
  padding-top: 60px;
  color: #90a4ae;
}
</style>