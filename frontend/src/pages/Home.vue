<template>
  <div class="page-bg">
    <v-container class="page-container">
      <v-row align="center" class="mb-6">
        <v-col cols="12">
          <h1 class="page-title">Welcome</h1>
          <p class="page-sub">Good to see you! Head to the Dashboard to check your progress.</p>
        </v-col>
      </v-row>

      <!-- Quick Links -->
      <v-row class="mb-6">
        <v-col cols="12" sm="4" v-for="card in quickLinks" :key="card.name">
          <v-card :to="card.to" class="quick-card" elevation="0" rounded="xl">
            <v-card-text class="d-flex align-center" style="gap:16px; padding: 20px 24px;">
              <div class="card-icon-wrap" :style="{ background: card.bg }">
                <v-icon :color="card.color" size="24">{{ card.icon }}</v-icon>
              </div>
              <div>
                <div class="card-title">{{ card.name }}</div>
                <div class="card-sub">{{ card.desc }}</div>
              </div>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>

      <!-- Battle Calendar -->
      <div class="section-block">
        <div class="section-header mb-4">
          <v-icon color="#1A73E8" size="20">mdi-calendar-month</v-icon>
          <h2 class="section-title">Battle Calendar</h2>
        </div>

        <div class="calendar-layout">
          <!-- Calendar -->
          <div class="calendar-side">
            <v-date-picker show-adjacent-months elevation="0" width="100%" color="#1A73E8" class="calendar-picker"
              v-model="selectedDate">
              <template #day="{ item, props }">
                <div class="day-wrapper">
                  <v-btn v-bind="props" />
                  <span v-if="isBattleDate(item.date)" class="battle-dot" />
                </div>
              </template>
            </v-date-picker>
          </div>

          <!-- Battles panel -->
          <div class="battles-side">
            <div v-if="!selectedDate" class="no-selection">
              <v-icon size="40" color="#d0d7e2">mdi-calendar-cursor</v-icon>
              <p>Select a day to see battles</p>
            </div>

            <div v-else-if="selectedBattles.length === 0" class="no-selection">
              <v-icon size="40" color="#d0d7e2">mdi-sword-cross</v-icon>
              <p>No battles on<br><strong>{{ formatSelectedDate }}</strong></p>
            </div>

            <div v-else>
              <p class="battles-day-label">{{ formatSelectedDate }}</p>
              <div v-for="battle in selectedBattles" :key="battle.id" class="battle-card">
                <div class="battle-left">
                  <div class="battle-club">{{ battle.club?.name }}</div>
                  <div class="battle-time" v-if="battle.time">
                    <v-icon size="13" color="#1A73E8">mdi-clock-outline</v-icon>
                    {{ battle.time.slice(0, 5) }}
                  </div>
                </div>
                <div class="battle-right">
                  <button
                    v-if="battle.status === 'finished' && !battle.grade_added"
                    class="btn-add-grade"
                    @click="addGrade(battle)"
                  >
                    <v-icon size="13">mdi-school</v-icon> Add Grade
                  </button>
                  <span :class="'status-badge status-' + battle.status">{{ battle.status }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </v-container>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';

const battles = ref([]);
const selectedDate = ref(null);
const router = useRouter();

const addGrade = async (battle) => {
  try {
    const token = localStorage.getItem('token');
    await axios.post(
      `http://localhost:3000/api/auth/battles/${battle.id}/grade-added`,
      {},
      { headers: { Authorization: `Bearer ${token}` } }
    );
    const target = battles.value.find(b => b.id === battle.id);
    if (target) target.grade_added = true;
    router.push({ name: 'AddGrade' });
  } catch (error) {
    console.error('Error marking grade:', error);
  }
};

const quickLinks = [
  { name: 'Dashboard', desc: 'Charts, grades & calendar', to: '/dashboard', icon: 'mdi-view-dashboard', color: '#1A73E8', bg: '#e8f0fe' },
  { name: 'Clubs', desc: 'Explore and join clubs', to: '/clubs', icon: 'mdi-account-group', color: '#0f9d58', bg: '#e6f4ea' },
  { name: 'Battles', desc: 'Compete with others', to: '/battles', icon: 'mdi-sword-cross', color: '#e53935', bg: '#fce8e6' },
];

const loadBattles = async () => {
  try {
    const token = localStorage.getItem('token');
    const res = await axios.get('http://localhost:3000/api/auth/battles', {
      headers: { Authorization: `Bearer ${token}` }
    });
    if (res.data.success) battles.value = res.data.battles;
  } catch (e) {
    console.error('Error loading battles:', e);
  }
};

const isBattleDate = (date) => {
  if (!date) return false;
  const d = new Date(date).toDateString();
  return battles.value.some(b => new Date(b.date).toDateString() === d);
};

const selectedBattles = computed(() => {
  if (!selectedDate.value) return [];
  const selected = new Date(selectedDate.value).toDateString();
  return battles.value.filter(b => new Date(b.date).toDateString() === selected);
});

const formatSelectedDate = computed(() => {
  if (!selectedDate.value) return '';
  return new Date(selectedDate.value).toLocaleDateString('en-GB', {
    weekday: 'long', day: 'numeric', month: 'long'
  });
});

onMounted(() => loadBattles());
</script>

<style scoped>
.page-bg {
  background-color: #f0f2f5;
  min-height: 100vh;
}

.page-container {
  padding-top: 4vh;
}

.page-title {
  font-size: 1.6rem;
  font-weight: 700;
  color: #1a1a2e;
  margin-bottom: 4px;
}

.page-sub {
  color: #5f6b7a;
  font-size: 0.9rem;
}

.quick-card {
  background: white;
  border: 1px solid #e8edf5;
  transition: box-shadow 0.18s, transform 0.18s;
  cursor: pointer;
}

.quick-card:hover {
  box-shadow: 0 4px 16px rgba(26, 115, 232, 0.12) !important;
  transform: translateY(-2px);
}

.card-icon-wrap {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.card-title {
  font-weight: 700;
  font-size: 0.95rem;
  color: #1a1a2e;
}

.card-sub {
  font-size: 0.8rem;
  color: #5f6b7a;
}

.section-block {
  background: white;
  border-radius: 16px;
  padding: 20px 24px;
  border: 1px solid #e8edf5;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-title {
  font-size: 1rem;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0;
}

.calendar-layout {
  display: flex;
  gap: 24px;
  align-items: flex-start;
}

.calendar-side {
  flex: 1;
  min-width: 0;
}

.calendar-picker {
  border-radius: 12px !important;
  border: 1px solid #e8edf5 !important;
  overflow: hidden;
}

.day-wrapper {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.battle-dot {
  position: absolute;
  bottom: 2px;
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background-color: #1A73E8;
}

.battles-side {
  width: 260px;
  flex-shrink: 0;
  min-height: 220px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}

.no-selection {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 200px;
  gap: 10px;
  color: #a0aab8;
  text-align: center;
  font-size: 0.88rem;
}

.battles-day-label {
  font-weight: 700;
  font-size: 0.9rem;
  color: #1A73E8;
  text-transform: capitalize;
  margin-bottom: 12px;
}

.battle-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #f8f9fc;
  border-radius: 10px;
  padding: 10px 14px;
  margin-bottom: 8px;
  border: 1px solid #e8edf5;
}

.battle-left {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.battle-club {
  font-weight: 700;
  font-size: 0.88rem;
  color: #1a1a2e;
}

.battle-time {
  font-size: 0.78rem;
  color: #5f6b7a;
  display: flex;
  align-items: center;
  gap: 3px;
}

.status-badge {
  padding: 3px 10px;
  border-radius: 20px;
  font-size: 0.75rem;
  font-weight: 700;
}

.status-scheduled {
  background: #fff8e1;
  color: #f9a825;
}

.status-ongoing {
  background: #e8f5e9;
  color: #2e7d32;
}

.status-finished {
  background: #f0f2f5;
  color: #5f6b7a;
}

.battle-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4px;
}

.btn-add-grade {
  display: flex;
  align-items: center;
  gap: 3px;
  background-color: #1558b0;
  color: #fff;
  border: none;
  border-radius: 6px;
  padding: 2px 8px;
  font-size: 0.72rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.18s;
  white-space: nowrap;
}

.btn-add-grade:hover {
  background-color: #0f3f80;
}
</style>