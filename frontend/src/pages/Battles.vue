<template>
  <div class="page-bg">
    <v-container class="page-container">
      <v-row class="mb-4">
        <v-col>
          <h1 class="page-title">Battles</h1>
          <p class="page-sub">Todas as battles dos teus clubes</p>
        </v-col>
      </v-row>
      <div class="section-block">
        <div class="section-header mb-4">
          <v-icon color="#1A73E8" size="20">mdi-sword-cross</v-icon>
          <h2 class="section-title">Próximas Battles</h2>
        </div>
        <div v-if="battles.length === 0" class="empty-row">
          Nenhuma battle agendada
        </div>
        <template v-for="(group, month) in battlesByMonth" :key="month">
          <div class="month-header">{{ month }}</div>
          <div v-for="battle in group" :key="battle.id" class="battle-item">
          <div class="battle-info">
            <span class="battle-club">{{ battle.club?.name }}</span>
            <span class="battle-date">
              <v-icon size="14" color="#5f6b7a">mdi-calendar</v-icon>
              {{ new Date(battle.date).toLocaleDateString("pt-PT") }}
            </span>
          </div>
          <div class="battle-end">
            <button
              v-if="battle.status === 'finished' && !battle.grade_added"
              class="btn-add-grade"
              @click="addGrade(battle)"
            >
              Add Grade
            </button>
            <span :class="'status-badge status-' + battle.status">{{
              battle.status
            }}</span>
          </div>
        </div>
        </template>
      </div>
    </v-container>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import axios from "axios";
import { useRouter } from "vue-router";

const battles = ref([]);
const router = useRouter();

const battlesByMonth = computed(() => {
  const groups = {};
  const sorted = [...battles.value].sort((a, b) => new Date(b.date) - new Date(a.date));
  for (const battle of sorted) {
    const key = new Date(battle.date).toLocaleDateString("pt-PT", { month: "long", year: "numeric" });
    if (!groups[key]) groups[key] = [];
    groups[key].push(battle);
  }
  return groups;
});

const loadBattles = async () => {
  try {
    const token = localStorage.getItem("token");
    const response = await axios.get("http://localhost:3000/api/auth/battles", {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (response.data.success) battles.value = response.data.battles;
  } catch (error) {
    console.error("Error loading battles:", error);
  }
};

const addGrade = async (battle) => {
  try {
    const token = localStorage.getItem("token");
    await axios.post(
      `http://localhost:3000/api/auth/battles/${battle.id}/grade-added`,
      {},
      { headers: { Authorization: `Bearer ${token}` } }
    );
    const target = battles.value.find(b => b.id === battle.id);
    if (target) target.grade_added = true;
    router.push({ name: "AddGrade" });
  } catch (error) {
    console.error("Error marking grade:", error);
  }
};

onMounted(() => loadBattles());
</script>

<style scoped>
.battle-end {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4px;
}
.btn-add-grade {
  background-color: #1558b0;
  border: 1px solid #d0d7e3;
  border-radius: 8px;
  padding: 2px 10px;
  font-size: 0.78rem;
  color: #ffffff;
  cursor: pointer;
}
.btn-add-grade:hover {
  background-color: #0f3f80;
}
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
}
.page-sub {
  color: #5f6b7a;
  font-size: 0.9rem;
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
.battle-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid #f0f2f5;
}
.battle-item:last-child {
  border-bottom: none;
}
.battle-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.battle-club {
  font-weight: 700;
  color: #1a1a2e;
  font-size: 0.9rem;
}
.battle-date {
  color: #5f6b7a;
  font-size: 0.82rem;
  display: flex;
  align-items: center;
  gap: 4px;
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
.month-header {
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #1A73E8;
  padding: 12px 16px 4px;
  border-bottom: 1px solid #e8edf5;
  margin-top: 4px;
}
.empty-row {
  text-align: center;
  color: #5f6b7a;
  padding: 24px;
  font-size: 0.9rem;
}
</style>