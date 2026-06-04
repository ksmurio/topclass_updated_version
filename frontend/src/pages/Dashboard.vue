<template>
  <div class="page-bg">
    <v-container class="page-container">
      <v-row align="center" class="mb-6">
        <v-col cols="12" sm="8">
          <h1 class="page-title">Dashboard</h1>
          <p class="page-sub">Here is the summary of your academic progress.</p>
        </v-col>
        <v-col cols="12" sm="4" class="d-flex justify-end">
          <v-btn
            color="#1A73E8"
            variant="flat"
            :to="{ name: 'AddGrade' }"
            class="action-btn"
          >
            <v-icon start>mdi-plus</v-icon> Add Academic Average
          </v-btn>
        </v-col>
      </v-row>

      <div class="section-block mb-6">
        <div class="section-header mb-4">
          <v-icon color="#1A73E8" size="20">mdi-chart-bar</v-icon>
          <h2 class="section-title">Average per Subject</h2>
        </div>
        <div v-if="chartGrades.length === 0" class="empty-row">
          No grades found
        </div>
        <div v-if="chartGrades.length > 0">
          <canvas ref="chartRef" height="120"></canvas>
        </div>
      </div>

      <div class="section-block mb-6">
        <div class="section-header mb-4">
          <v-icon color="#1A73E8" size="20">mdi-chart-line</v-icon>
          <h2 class="section-title">Grade History</h2>
        </div>
        <div v-if="gradesHistory.length === 0" class="empty-row">
          No grades found
        </div>
        <div v-else class="history-layout">
          <div class="subject-list">
            <div
              v-for="item in gradesHistory"
              :key="item.subject"
              class="subject-item"
              :class="{ active: selectedSubject === item.subject }"
              @click="selectSubject(item)"
            >
              <span class="subject-name">{{ item.subject }}</span>
              <span class="subject-count"
                >{{ item.entries.length }} grade{{
                  item.entries.length > 1 ? "s" : ""
                }}</span
              >
            </div>
          </div>
          <div class="line-chart-area">
            <div
              v-if="!selectedSubject"
              class="empty-row"
              style="
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
              "
            >
              Select a subject to view its history
            </div>
            <div v-else style="position: relative">
              <p class="chart-subject-label">{{ selectedSubject }}</p>
              <canvas ref="lineChartRef" height="180"></canvas>
            </div>
          </div>
        </div>
      </div>
    </v-container>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from "vue";
import axios from "axios";
import Chart from "chart.js/auto";

const chartRef = ref(null);
const chartGrades = ref([]);
const lineChartRef = ref(null);
const gradesHistory = ref([]);
const selectedSubject = ref(null);
let lineChartInstance = null;
let maxHeight = 0;

const renderBarChart = (max) => {
  if (!chartRef.value) return;
  if (chartRef.value._chartInstance) chartRef.value._chartInstance.destroy();
  chartRef.value._chartInstance = new Chart(chartRef.value, {
    type: "bar",
    data: {
      labels: chartGrades.value.map((g) => g.subject),
      datasets: [
        {
          label: "Average",
          data: chartGrades.value.map((g) => parseFloat(g.average)),
          backgroundColor: "#1A73E8",
          borderRadius: 8,
        },
      ],
    },
    options: {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: {
        y: { min: 0, max: max, grid: { color: "#f0f2f5" } },
        x: { grid: { display: false } },
      },
    },
  });
};

const loadBarChart = async () => {
  try {
    const token = localStorage.getItem("token");
    const user = await axios
      .get("http://localhost:3000/api/auth/user", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((r) => r.data.user)
      .catch(() => null);
    maxHeight = parseInt(user?.school_year) <= 5 ? 5 : 20;
    const res = await axios.get("http://localhost:3000/api/auth/grades/chart", {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (res.data.success) {
      chartGrades.value = res.data.grades;
      await nextTick();
      renderBarChart(maxHeight);
    }
  } catch (e) {
    console.error(e);
  }
};

const renderLineChart = async (entries) => {
  await nextTick();
  if (!lineChartRef.value) return;
  if (lineChartInstance) lineChartInstance.destroy();
  lineChartInstance = new Chart(lineChartRef.value, {
    type: "line",
    data: {
      labels: entries.map((e) =>
        new Date(e.date).toLocaleDateString("pt-PT", {
          day: "2-digit",
          month: "short",
          year: "numeric",
        }),
      ),
      datasets: [
        {
          label: "Grade",
          data: entries.map((e) => e.grade),
          borderColor: "#1A73E8",
          backgroundColor: "rgba(26,115,232,0.08)",
          borderWidth: 2.5,
          pointBackgroundColor: "#1A73E8",
          pointRadius: 5,
          pointHoverRadius: 7,
          tension: 0.35,
          fill: true,
        },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false },
        tooltip: { callbacks: { label: (ctx) => ` Grade: ${ctx.parsed.y}` } },
      },
      scales: {
        y: {
          min: 0,
          max: maxHeight || 20,
          grid: { color: "#f0f2f5" },
          ticks: { stepSize: maxHeight <= 5 ? 1 : 2 },
        },
        x: { grid: { display: false } },
      },
    },
  });
};

const selectSubject = (item) => {
  selectedSubject.value = item.subject;
  renderLineChart(item.entries);
};

const loadGradesHistory = async () => {
  try {
    const token = localStorage.getItem("token");
    const res = await axios.get(
      "http://localhost:3000/api/auth/grades/history",
      { headers: { Authorization: `Bearer ${token}` } },
    );
    if (res.data.success) gradesHistory.value = res.data.grades;
  } catch (e) {
    console.error(e);
  }
};

onMounted(() => {
  loadBarChart();
  loadGradesHistory();
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
  border-color: #1a73e8;
}
.subject-item.active {
  background: #1a73e8;
  border-color: #1a73e8;
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
  color: #1a73e8;
  font-size: 0.9rem;
  margin-bottom: 8px;
}
</style>
