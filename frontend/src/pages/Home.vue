<template>
  <div class="page-bg">
    <v-container class="page-container">
      <v-row align="center" class="mb-6">
        <v-col cols="12" sm="8">
          <h1 class="page-title">Welcome</h1>
          <p class="page-sub">Here is the summary of your progress and your activities this week.</p>
        </v-col>
        <v-col cols="12" sm="4" class="d-flex justify-end">
          <v-btn color="#1A73E8" variant="flat" :to="{ name: 'AddGrade' }" class="action-btn">
            <v-icon start>mdi-plus</v-icon> Add Academic Average
          </v-btn>
        </v-col>
      </v-row>

      <div class="section-block mb-6">
        <div class="section-header mb-4">
          <v-icon color="#1A73E8" size="20">mdi-chart-bar</v-icon>
          <h2 class="section-title">Average per Subject</h2>
        </div>
        <div v-if="chartGrades.length === 0" class="empty-row">No grades found</div>
        <div v-if="chartGrades.length > 0">
          <canvas ref="chartRef" height="120"></canvas>
        </div>
      </div>

      <div class="section-block mb-6">
        <div class="section-header mb-4">
          <v-icon color="#1A73E8" size="20">mdi-chart-line</v-icon>
          <h2 class="section-title">Grade History</h2>
        </div>

        <div v-if="gradesHistory.length === 0" class="empty-row">No grades found</div>

        <div v-else class="history-layout">
          <div class="subject-list">
            <div v-for="item in gradesHistory" :key="item.subject" class="subject-item"
              :class="{ active: selectedSubject === item.subject }" @click="selectSubject(item)">
              <span class="subject-name">{{ item.subject }}</span>
              <span class="subject-count">{{ item.entries.length }} grade{{ item.entries.length > 1 ? 's' : '' }}</span>
            </div>
          </div>

          <div class="line-chart-area">
            <div v-if="!selectedSubject" class="empty-row"
              style="height:100%;display:flex;align-items:center;justify-content:center;">
              Select a subject to view its history
            </div>
            <div v-else style="position:relative;">
              <p class="chart-subject-label">{{ selectedSubject }}</p>
              <canvas ref="lineChartRef" height="180"></canvas>
            </div>
          </div>
        </div>
      </div>

      <div class="section-block mb-6">
        <div class="section-header mb-4">
          <v-icon color="#1A73E8" size="20">mdi-calendar</v-icon>
          <h2 class="section-title">Battle Calendar</h2>
        </div>
        <v-row justify="center">
          <v-col cols="12" md="8" lg="6" class="d-flex justify-center">
            <v-date-picker show-adjacent-months elevation="0" width="100%" color="#1A73E8" class="calendar-picker"
              v-model="selectedDate">
              <template #day="{ item, props }">
                <div class="day-wrapper">
                  <v-btn v-bind="props" />
                  <span v-if="isBattleDate(item.date)" class="battle-dot" />
                </div>
              </template>
            </v-date-picker>
          </v-col>
        </v-row>

        <div v-if="selectedBattles.length > 0" class="battles-on-day mt-4">
          <div class="section-header mb-3">
            <v-icon color="#1A73E8" size="16">mdi-sword-cross</v-icon>
            <span class="section-title" style="font-size:0.9rem">
              Battles em {{ formatSelectedDate }}
            </span>
          </div>
          <div v-for="battle in selectedBattles" :key="battle.id" class="battle-item">
            <div class="battle-info">
              <span class="battle-club">{{ battle.club?.name }}</span>
              <span class="battle-date">
                <v-icon size="14" color="#5f6b7a">mdi-calendar</v-icon>
                {{ new Date(battle.date).toLocaleDateString('pt-PT') }}
                <span v-if="battle.time">· {{ battle.time.slice(0, 5) }}</span>
              </span>
            </div>
            <span :class="'status-badge status-' + battle.status">{{ battle.status }}</span>
          </div>
        </div>

        <div v-else-if="selectedDate" class="empty-row">
          Nenhuma battle neste dia
        </div>
      </div>
    </v-container>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, computed } from 'vue';
import axios from 'axios';
import Chart from 'chart.js/auto';

const chartRef = ref(null);
const chartGrades = ref([]);

const lineChartRef = ref(null);
const gradesHistory = ref([]);
const selectedSubject = ref(null);
let lineChartInstance = null;

const battles = ref([]);
const selectedDate = ref(null);

let maxHeight = 0;

const renderBarChart = (max) => {
  if (!chartRef.value) return;
  if (chartRef.value._chartInstance) chartRef.value._chartInstance.destroy();
  chartRef.value._chartInstance = new Chart(chartRef.value, {
    type: 'bar',
    data: {
      labels: chartGrades.value.map(g => g.subject),
      datasets: [{
        label: 'Average',
        data: chartGrades.value.map(g => parseFloat(g.average)),
        backgroundColor: '#1A73E8',
        borderRadius: 8,
      }]
    },
    options: {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: {
        y: { min: 0, max: max, grid: { color: '#f0f2f5' } },
        x: { grid: { display: false } }
      }
    }
  });
};

const loadBarChart = async () => {
  try {
    const token = localStorage.getItem('token');
    const user = await axios.get('http://localhost:3000/api/auth/user', {
      headers: { Authorization: `Bearer ${token}` }
    }).then(r => r.data.user).catch(() => null);

    maxHeight = parseInt(user?.school_year) <= 5 ? 5 : 20;

    const res = await axios.get('http://localhost:3000/api/auth/grades/chart', {
      headers: { Authorization: `Bearer ${token}` }
    });
    if (res.data.success) {
      chartGrades.value = res.data.grades;
      await nextTick();
      renderBarChart(maxHeight);
    }
  } catch (e) {
    console.error('Error loading bar chart:', e);
  }
};

const renderLineChart = async (entries) => {
  await nextTick();
  if (!lineChartRef.value) return;
  if (lineChartInstance) lineChartInstance.destroy();

  const labels = entries.map(e =>
    new Date(e.date).toLocaleDateString('pt-PT', { day: '2-digit', month: 'short', year: 'numeric' })
  );
  const data = entries.map(e => e.grade);

  lineChartInstance = new Chart(lineChartRef.value, {
    type: 'line',
    data: {
      labels,
      datasets: [{
        label: 'Grade',
        data,
        borderColor: '#1A73E8',
        backgroundColor: 'rgba(26,115,232,0.08)',
        borderWidth: 2.5,
        pointBackgroundColor: '#1A73E8',
        pointRadius: 5,
        pointHoverRadius: 7,
        tension: 0.35,
        fill: true,
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: ctx => ` Grade: ${ctx.parsed.y}`
          }
        }
      },
      scales: {
        y: {
          min: 0,
          max: maxHeight || 20,
          grid: { color: '#f0f2f5' },
          ticks: { stepSize: maxHeight <= 5 ? 1 : 2 }
        },
        x: { grid: { display: false } }
      }
    }
  });
};

const selectSubject = (item) => {
  selectedSubject.value = item.subject;
  renderLineChart(item.entries);
};

const loadGradesHistory = async () => {
  try {
    const token = localStorage.getItem('token');
    const res = await axios.get('http://localhost:3000/api/auth/grades/history', {
      headers: { Authorization: `Bearer ${token}` }
    });
    if (res.data.success) {
      gradesHistory.value = res.data.grades;
    }
  } catch (e) {
    console.error('Error loading grades history:', e);
  }
};

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
  return new Date(selectedDate.value).toLocaleDateString('pt-PT', {
    day: 'numeric', month: 'long', year: 'numeric'
  });
});

onMounted(() => {
  loadBarChart();
  loadGradesHistory();
  loadBattles();
});
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

.action-btn {
  border-radius: 8px !important;
  font-weight: 600;
  color: white !important;
  height: 44px !important;
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

.empty-row {
  text-align: center;
  color: #5f6b7a;
  padding: 24px;
  font-size: 0.9rem;
}

.history-layout {
  display: flex;
  gap: 20px;
}

.subject-list {
  width: 200px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 340px;
  overflow-y: auto;
}

.subject-item {
  padding: 10px 14px;
  border-radius: 10px;
  background: #f8f9fc;
  cursor: pointer;
  border: 1.5px solid transparent;
  transition: all 0.18s;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.subject-item:hover {
  background: #eef3fd;
  border-color: #1A73E8;
}

.subject-item.active {
  background: #1A73E8;
  border-color: #1A73E8;
}

.subject-item.active .subject-name {
  color: white;
}

.subject-item.active .subject-count {
  color: rgba(255, 255, 255, 0.75);
}

.subject-name {
  font-weight: 700;
  font-size: 0.88rem;
  color: #1a1a2e;
}

.subject-count {
  font-size: 0.75rem;
  color: #5f6b7a;
}

.line-chart-area {
  flex: 1;
  min-width: 0;
}

.chart-subject-label {
  font-weight: 700;
  color: #1A73E8;
  font-size: 0.9rem;
  margin-bottom: 8px;
}

.calendar-picker {
  border-radius: 16px !important;
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

.battles-on-day {
  border-top: 1px solid #f0f2f5;
  padding-top: 16px;
}

.battle-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 12px;
  border-radius: 10px;
  background: #f8f9fc;
  margin-bottom: 8px;
}

.battle-info {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.battle-club {
  font-weight: 700;
  color: #1a1a2e;
  font-size: 0.9rem;
}

.battle-time {
  color: #5f6b7a;
  font-size: 0.82rem;
  display: flex;
  align-items: center;
  gap: 3px;
}

.status-badge {
  padding: 2px 10px;
  border-radius: 20px;
  font-size: 0.78rem;
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
</style>