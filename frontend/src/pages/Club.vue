<template>
    <div class="page-bg">
        <v-container class="page-container">

            <v-row class="mb-4">
                <v-col cols="12" sm="8">
                    <h1 class="page-title">Dashboard</h1>
                    <p class="page-sub">Analyze school average, track rankings.</p>
                </v-col>
                <v-col cols="12" sm="4" style="display:flex; justify-content:flex-end; align-items:center; gap:8px">
                    <v-btn @click="$router.push(`/club/${club.id}/community`)" color="#1A73E8" variant="flat" class="action-btn">
                        <v-icon start>mdi-sword-cross</v-icon> Community
                    </v-btn>
                    <v-btn v-if="isCreator" @click="dialog = true" color="#1A73E8" variant="flat" class="action-btn">
                        <v-icon start>mdi-sword-cross</v-icon> Create Battle
                    </v-btn>
                    <v-btn v-if="isMember == false" @click="joinClub()" color="#1A73E8" variant="flat"
                        class="action-btn">
                        <v-icon start>mdi-account-plus</v-icon> Join Club
                    </v-btn>
                    <v-btn v-if="isCreator" @click="deleteClub()" color="error" variant="outlined"
                        class="action-btn-outline">
                        <v-icon start>mdi-delete</v-icon> Delete Club
                    </v-btn>
                    <v-btn v-if="isMember && !isCreator" @click="leaveClub()" color="error" variant="outlined"
                        class="action-btn-outline">
                        <v-icon start>mdi-logout</v-icon> Leave Club
                    </v-btn>
                </v-col>
            </v-row>

            <v-dialog v-model="dialog" max-width="480">
                <v-card class="dialog-card">
                    <v-card-text>
                        <h3 class="card-title mb-1">New Battle</h3>
                        <p class="card-subtitle mb-6">Choose the date for the battle</p>
                        <v-text-field v-model="battleDate" label="Battle Date" type="date" variant="outlined"
                            density="comfortable" />
                        <v-text-field v-model="battleTime" label="Battle Time" type="time" variant="outlined"
                            density="comfortable" />
                    </v-card-text>
                    <v-card-actions class="px-4 pb-4" style="gap:8px">
                        <v-btn variant="outlined" style="border-color:#e8edf5;color:#5f6b7a;border-radius:8px;flex:1"
                            @click="dialog = false">Cancel</v-btn>
                        <v-btn variant="flat" style="background:#1A73E8;color:white;border-radius:8px;flex:1"
                            @click="createBattle()">Confirm</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>

            <v-dialog v-model="profileDialog" max-width="400">
                <v-card class="dialog-card" v-if="selectedMember">
                    <v-card-text class="pb-4">
                        <div class="profile-dialog-header">
                            <v-avatar size="72" class="mb-3">
                                <v-img v-if="selectedMember.profile_picture"
                                    :src="`http://localhost:3000/uploads/${selectedMember.profile_picture}`" />
                                <v-icon v-else size="52" color="#1A73E8">mdi-account-circle</v-icon>
                            </v-avatar>
                            <h3 class="card-title mb-0">{{ selectedMember.name }}</h3>
                            <span class="profile-username">@{{ selectedMember.username }}</span>
                        </div>
                        <div class="profile-info-row">
                            <span class="info-label">Email</span>
                            <span class="info-value">{{ selectedMember.email }}</span>
                        </div>
                        <div class="profile-info-row">
                            <span class="info-label">Ano Escolar</span>
                            <span class="info-value">{{ selectedMember.school_year }}º ano</span>
                        </div>
                        <div class="profile-info-row">
                            <span class="info-label">Média Global</span>
                            <span class="avg-badge">{{ selectedMember.global_average ?? '-' }}</span>
                        </div>
                        <div class="profile-info-row">
                            <span class="info-label">Média {{ club?.subject?.name }}</span>
                            <span class="avg-badge">{{ selectedMember.subject_average ?? '-' }}</span>
                        </div>
                    </v-card-text>
                    <v-card-actions class="px-4 pb-4">
                        <v-btn variant="outlined"
                            style="border-color:#e8edf5;color:#5f6b7a;border-radius:8px;width:100%"
                            @click="profileDialog = false">Fechar</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>

            <div class="section-block mb-4" style="height:70vh; display:flex; flex-direction:column;">
                <div class="section-header mb-4">
                    <v-icon color="#1A73E8" size="20">mdi-account-group</v-icon>
                    <h2 class="section-title">Members</h2>
                    <span v-if="club?.subject?.name" class="club-type-badge">{{ club.subject.name }}</span>
                    <span v-if="club" class="club-id-badge">ID: {{ club.id }}</span>
                </div>

                <div style="flex:1; overflow-y:auto;">
                    <v-table class="members-table">
                        <thead>
                            <tr>
                                <th class="th-rank">Rank</th>
                                <th>Member</th>
                                <th>Subject Average</th>
                                <th>Profile</th>
                                <th v-if="isCreator">Action</th>
                            </tr>
                        </thead>
                        <tbody v-if="club">
                            <tr v-for="(member, i) in members" :key="member.id || i" class="member-row">
                                <td class="rank-cell">
                                    <span class="rank-badge">{{ i + 1 }}</span>
                                </td>
                                <td class="member-name">{{ member.username }}</td>
                                <td>
                                    <span class="avg-badge">{{ member.subject_average ?? '-' }}</span>
                                </td>
                                <td>
                                    <v-btn size="small" color="#1A73E8" variant="flat" class="view-btn"
                                        @click="openProfile(member)">Ver</v-btn>
                                </td>
                                <td v-if="isCreator">
                                    <v-btn size="small" color="error" variant="outlined"
                                        @click="deleteMember(member.id)">
                                        <v-icon size="16">mdi-close</v-icon>
                                    </v-btn>
                                </td>
                            </tr>
                            <tr v-if="members.length === 0">
                                <td colspan="5" class="empty-row">Nenhum membro encontrado</td>
                            </tr>
                        </tbody>
                    </v-table>
                </div>
            </div>


            <div class="section-block mt-4" v-if="members.length > 0">
                <div class="section-header mb-4">
                    <v-icon color="#1A73E8" size="20">mdi-trophy</v-icon>
                    <h2 class="section-title">Ranking</h2>
                </div>
                <div style="position:relative; width:100%;"
                    :style="{ height: Math.max(members.length * 48 + 60, 200) + 'px' }">
                    <canvas ref="chartCanvas"></canvas>
                </div>
            </div>

        </v-container>
    </div>
</template>

<script setup>
import { ref, onMounted, computed, nextTick, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import axios from 'axios';

const dialog = ref(false);
const profileDialog = ref(false);
const selectedMember = ref(null);
const battleDate = ref('');
const battleTime = ref('');
const router = useRouter();
const route = useRoute();
const club = ref(null);
const isMember = ref(true);
const isCreator = ref(false);
const chartCanvas = ref(null);
let chartInstance = null;

const members = computed(() => club.value?.members ?? []);

const openProfile = (member) => {
    selectedMember.value = member;
    profileDialog.value = true;
};

const buildChart = () => {
    if (!chartCanvas.value || members.value.length === 0) return;

    const sortedMembers = [...members.value].sort((memberA, memberB) =>
        (parseFloat(memberB.subject_average) || 0) - (parseFloat(memberA.subject_average) || 0)
    );

    const names = sortedMembers.map(member => member.username);
    const averages = sortedMembers.map(member => parseFloat(member.subject_average) || 0);

    const barColors = averages.map((_, position) => {
        if (position === 0) return '#1A73E8';
        if (position === 1) return '#4A90D9';
        if (position === 2) return '#7BB3E8';
        return '#B8D4F5';
    });

    if (chartInstance) { chartInstance.destroy(); }

    chartInstance = new Chart(chartCanvas.value, {
        type: 'bar',
        data: {
            labels: names,
            datasets: [{
                label: 'Average',
                data: averages,
                backgroundColor: barColors,
                borderRadius: 6,
                borderSkipped: false,
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false, //se true o gráfico redimensiona-se para preencher totalmente a altura e largura do contêiner pai,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: tooltip => ` ${tooltip.parsed.x.toFixed(2)} values`
                    }
                }
            },
            scales: {
                x: {
                    min: 0,
                    max: 20,
                    grid: { color: 'rgba(0,0,0,0.05)' },
                    ticks: { font: { size: 12 } }
                },
                y: {
                    grid: { display: false },
                    ticks: { font: { size: 13, weight: '600' } }
                }
            }
        }
    });
};

const load_club = async () => {
    try {
        const clubId = route.params.id;
        const token = localStorage.getItem('token');
        if (!clubId) return;
        const response = await axios.get(`http://localhost:3000/api/auth/club/${clubId}`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if (response.data.success) {
            club.value = response.data.club;
            club.value.members = response.data.membersWithAvg;
            isMember.value = response.data.isMember;
            isCreator.value = response.data.isCreator;
            await nextTick();
            loadChartJS();
        }
    } catch (error) {
        console.error("Error loading club:", error);
    }
};

const loadChartJS = () => {
    if (window.Chart) { buildChart(); return; } //carrega da internet em tempo real
    const script = document.createElement('script');
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js';
    script.onload = () => buildChart();
    document.head.appendChild(script);
};

const joinClub = async () => {
    try {
        const clubId = route.params.id;
        const token = localStorage.getItem('token');
        const response = await axios.post(`http://localhost:3000/api/auth/club/${clubId}`, {}, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if (response.data.success) { await load_club(); }
    } catch (error) {
        console.error("Error joining club:", error);
    }
};

const deleteClub = async () => {
    try {
        const clubId = route.params.id;
        const token = localStorage.getItem('token');
        if (!token) { router.push('/login'); return; }
        const response = await axios.delete(`http://localhost:3000/api/auth/club/${clubId}`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if (response.data.success) { router.push('/clubs'); }
    } catch (error) {
        console.error("Error deleting club:", error);
    }
};

const deleteMember = async (memberId) => {
    try {
        const token = localStorage.getItem('token');
        const clubId = route.params.id;
        const response = await axios.delete(`http://localhost:3000/api/auth/club/${clubId}/member/${memberId}`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if (response.data.success) { load_club(); }
    } catch (error) {
        console.error("Error deleting user " + error);
    }
};

const createBattle = async () => {
    const token = localStorage.getItem('token');
    const clubId = route.params.id;
    if (!token || !clubId || !battleDate.value || !battleTime.value) return;
    try {
        const response = await axios.post(
            `http://localhost:3000/api/auth/club/${clubId}/battle`,
            { date: battleDate.value, time: battleTime.value },
            { headers: { 'Authorization': `Bearer ${token}` } }
        );
        if (response.data.success) { dialog.value = false; load_club(); }
    } catch (error) {
        console.error("Error creating battle:", error);
    }
};

const leaveClub = async () => {
    try {
        const clubId = route.params.id;
        const token = localStorage.getItem('token');
        const response = await axios.delete(`http://localhost:3000/api/auth/club/${clubId}/leave`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if (response.data.success) { router.push('/clubs'); }
    } catch (error) {
        console.error("Error leaving club:", error);
    }
};

onMounted(() => { load_club(); });
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
    letter-spacing: -0.3px;
    margin-bottom: 4px;
}

.page-sub {
    color: #5f6b7a;
    font-size: 0.9rem;
}

.action-btn {
    border-radius: 8px !important;
    font-weight: 600;
    height: 40px !important;
    color: white !important;
}

.action-btn-outline {
    border-radius: 8px !important;
    font-weight: 600;
    height: 40px !important;
}

.dialog-card {
    border-radius: 16px !important;
    border: 1px solid #e8edf5 !important;
    box-shadow: 0 4px 24px rgba(26, 115, 232, 0.10) !important;
    padding: 8px 8px 0;
}

.card-title {
    font-size: 1.4rem;
    font-weight: 700;
    color: #1a1a2e;
    letter-spacing: -0.3px;
}

.card-subtitle {
    color: #1A73E8;
    font-size: 0.875rem;
}

.profile-dialog-header {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 8px 0 16px;
}

.profile-username {
    color: #5f6b7a;
    font-size: 0.88rem;
    margin-top: 2px;
}

.profile-info-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px solid #f0f2f5;
}

.profile-info-row:last-child {
    border-bottom: none;
}

.info-label {
    color: #5f6b7a;
    font-size: 0.88rem;
}

.info-value {
    font-weight: 600;
    color: #1a1a2e;
    font-size: 0.88rem;
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
    flex: 1;
}

.club-type-badge {
    font-size: 0.75rem;
    color: #7b1fa2;
    background: #f3e5f5;
    padding: 2px 10px;
    border-radius: 20px;
    font-weight: 600;
    text-transform: capitalize;
}

.club-id-badge {
    font-size: 0.75rem;
    color: #1A73E8;
    background: #EBF3FD;
    padding: 2px 10px;
    border-radius: 20px;
    font-weight: 600;
}

.members-table {
    border-radius: 10px;
    overflow: hidden;
    border: 1px solid #e8edf5;
}

.members-table th {
    background: #f7f9fc !important;
    color: #5f6b7a !important;
    font-size: 0.78rem !important;
    font-weight: 700 !important;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    padding: 12px 16px !important;
}

.member-row:hover {
    background: #f7f9fc;
}

.member-row td {
    padding: 12px 16px !important;
    border-bottom: 1px solid #f0f2f5;
}

.rank-cell {
    width: 60px;
}

.rank-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 28px;
    height: 28px;
    background: #EBF3FD;
    color: #1A73E8;
    border-radius: 50%;
    font-size: 0.8rem;
    font-weight: 700;
}

.member-name {
    font-weight: 600;
    color: #1a1a2e;
    font-size: 0.9rem;
}

.avg-badge {
    background: #e8f5e9;
    color: #2e7d32;
    padding: 2px 10px;
    border-radius: 20px;
    font-size: 0.82rem;
    font-weight: 600;
}

.view-btn {
    border-radius: 6px !important;
    color: white !important;
    font-weight: 600;
}

.empty-row {
    text-align: center;
    color: #5f6b7a;
    padding: 24px !important;
    font-size: 0.9rem;
}
</style>