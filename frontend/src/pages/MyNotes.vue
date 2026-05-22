<template>
  <div class="page-bg">


    <div class="missions-bar">
      <div class="missions-track" ref="track">
        <div v-if="missionsLoading" class="mission-loading">
          <v-progress-circular indeterminate color="#1A73E8" size="20" />
        </div>
        <div v-else-if="missions.length === 0" class="mission-empty">
          Nenhuma missão esta semana 
        </div>
        <div
          v-for="m in missions"
          :key="m.id"
          class="mission-card"
          :class="{ 'mission-done': m.completed }"
        >
          <div class="mission-card-top">
            <v-icon size="14" :color="m.completed ? '#4caf50' : '#1A73E8'">
              {{ m.completed ? 'mdi-check-circle' : 'mdi-flag' }}
            </v-icon>
            <span class="mission-due">{{ formatDate(m.due_date) }}</span>
          </div>
          <p class="mission-name">{{ m.name }}</p>
          <p class="mission-desc">{{ m.description }}</p>
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
              <v-text-field v-model="title" label="Title" placeholder="Note title..." variant="outlined" rounded class="mb-2" />
              <v-textarea v-model="note" label="Write your note" placeholder="Type something..." variant="outlined" rounded rows="4" :counter="200" :maxlength="200" />
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
                <v-btn icon size="small" variant="text" color="success" :loading="deletingId === n.id" @click="completeNote(n.id)">
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
const track = ref(null);

const getToken = () => localStorage.getItem('token');

const formatDate = (d) => d ? new Date(d).toLocaleDateString('pt-PT', { day: '2-digit', month: 'short' }) : '';

const fetchMissions = async () => {
  missionsLoading.value = true;
  try {
    const res = await fetch('http://localhost:3000/api/auth/getMissions', {
      headers: { Authorization: `Bearer ${getToken()}` },
    });
    const data = await res.json();
    if (data.success) missions.value = data.missions;
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

const completeNote = async (id) => {
  deletingId.value = id;
  try {
    const res = await fetch(`http://localhost:3000/api/auth/notes/${id}`, { method: 'DELETE', headers: { Authorization: `Bearer ${getToken()}` } });
    const data = await res.json();
    if (data.success) notes.value = notes.value.filter(n => n.id !== id);
  } catch (e) { console.error(e); } finally { deletingId.value = null; }
};


onMounted(() => {
  fetchNotes(); fetchMissions();
  const el = track.value;
  if (!el) return;
  let isDown = false, startX, scrollLeft;
  el.addEventListener('mousedown', e => { isDown = true; el.classList.add('dragging'); startX = e.pageX - el.offsetLeft; scrollLeft = el.scrollLeft; });
  el.addEventListener('mouseleave', () => { isDown = false; el.classList.remove('dragging'); });
  el.addEventListener('mouseup', () => { isDown = false; el.classList.remove('dragging'); });
  el.addEventListener('mousemove', e => { if (!isDown) return; e.preventDefault(); const x = e.pageX - el.offsetLeft; el.scrollLeft = scrollLeft - (x - startX); });
});
</script>

<style scoped>
.page-bg { background-color: #f0f2f5; min-height: 100vh; }
.page-container { padding-top: 4vh; }

/* MISSIONS BAR */
.missions-bar {
  width: 100%;
  background: #fff;
  border-bottom: 2px solid #1A73E8;
  padding: 10px 16px;
  box-shadow: 0 2px 8px rgba(26,115,232,0.08);
}
.missions-track {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  cursor: grab;
  scroll-behavior: smooth;
  padding-bottom: 4px;
  -webkit-overflow-scrolling: touch;
}
.missions-track::-webkit-scrollbar { height: 3px; }
.missions-track::-webkit-scrollbar-thumb { background: #1A73E8; border-radius: 4px; }
.missions-track.dragging { cursor: grabbing; }
.mission-card {
  min-width: 180px;
  max-width: 180px;
  background: #f0f4ff;
  border: 1px solid #c5d8f8;
  border-radius: 10px;
  padding: 10px 12px;
  flex-shrink: 0;
  user-select: none;
  transition: box-shadow 0.2s;
}
.mission-card:hover { box-shadow: 0 3px 12px rgba(26,115,232,0.15); }
.mission-done { background: #f1f8e9; border-color: #c8e6c9; opacity: 0.8; }
.mission-card-top { display: flex; align-items: center; gap: 6px; margin-bottom: 4px; }
.mission-due { font-size: 0.72rem; color: #999; }
.mission-name { font-weight: 700; font-size: 0.85rem; color: #1a1a2e; margin: 0 0 3px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.mission-desc { font-size: 0.75rem; color: #666; margin: 0; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.mission-loading, .mission-empty { display: flex; align-items: center; padding: 8px 12px; color: #999; font-size: 0.85rem; gap: 8px; }


.brand-header { display: flex; align-items: center; gap: 8px; }
.brand-name { font-size: 1.3rem; font-weight: 700; color: #1a1a2e; letter-spacing: -0.3px; }
.register-card { border-radius: 16px !important; box-shadow: 0 4px 24px rgba(26,115,232,0.08) !important; border: 1px solid #e8edf5 !important; padding: 8px 16px 4px; }
.card-title { font-size: 1.4rem; font-weight: 700; color: #1a1a2e; margin-bottom: 4px; }
.card-subtitle { color: #1A73E8; font-size: 0.875rem; }
.submit-btn { background-color: #1A73E8 !important; color: white !important; border-radius: 8px !important; font-weight: 600; font-size: 0.95rem; height: 48px !important; }
.note-card { border-radius: 12px !important; border: 1px solid #e8edf5 !important; box-shadow: 0 2px 12px rgba(26,115,232,0.06) !important; transition: box-shadow 0.2s; }
.note-card:hover { box-shadow: 0 4px 20px rgba(26,115,232,0.14) !important; }
.note-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 4px; }
.note-title { font-weight: 700; color: #1a1a2e; font-size: 1rem; margin: 0; }
.note-content { color: #444; font-size: 0.95rem; white-space: pre-wrap; margin-bottom: 8px; }
.empty-state { text-align: center; padding-top: 60px; color: #90a4ae; }
</style>