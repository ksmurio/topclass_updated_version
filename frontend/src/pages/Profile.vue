<template>
    <div class="page-bg">
        <v-container class="page-container">

            <v-btn v-if="isPublicView" icon variant="text" @click="$router.back()" class="mb-2">
                <v-icon>mdi-arrow-left</v-icon>
            </v-btn>

            <!-- Cabeçalho -->
            <div class="section-block mb-4">
                <div class="profile-header">
                    <v-avatar size="80" class="mb-3">
                        <v-img v-if="user.profile_picture"
                            :src="`http://localhost:3000/uploads/${user.profile_picture}`" />
                        <v-icon v-else size="60" color="#1A73E8">mdi-account-circle</v-icon>
                    </v-avatar>
                    <h1 class="profile-name">{{ user.name }}</h1>
                    <span class="profile-username">@{{ user.username }}</span>
                    <div class="profile-stats mt-3">
                        <div class="stat">
                            <span class="stat-value">{{ user.global_average || '—' }}</span>
                            <span class="stat-label">Média</span>
                        </div>
                        <div class="stat-divider"></div>
                        <div class="stat">
                            <span class="stat-value">{{ user.points || 0 }}</span>
                            <span class="stat-label">Pontos</span>
                        </div>
                        <div class="stat-divider"></div>
                        <div class="stat">
                            <span class="stat-value">{{ user.school_year ? user.school_year + 'º' : '—' }}</span>
                            <span class="stat-label">Ano</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Informações (só no próprio perfil) -->
            <div v-if="!isPublicView" class="section-block mb-4">
                <div class="section-header mb-4">
                    <v-icon color="#1A73E8" size="20">mdi-information-outline</v-icon>
                    <h2 class="section-title">Informações</h2>
                </div>
                <div class="info-row">
                    <span class="info-label">Email</span>
                    <span class="info-value">{{ user.email }}</span>
                </div>
            </div>

            <!-- Fotos -->
            <div class="section-block mb-4">
                <div class="section-header mb-4">
                    <v-icon color="#1A73E8" size="20">mdi-image-multiple-outline</v-icon>
                    <h2 class="section-title">Fotos</h2>
                    <v-spacer />
                    <v-btn v-if="!isPublicView" size="small" color="#1A73E8" variant="tonal" @click="triggerPhotoInput">
                        <v-icon size="16" class="mr-1">mdi-plus</v-icon> Adicionar
                    </v-btn>
                    <input ref="photoInput" type="file" accept="image/*" style="display:none" @change="uploadPhoto" />
                </div>

                <div v-if="!photos.length" class="empty-row">Sem fotos ainda.</div>

                <div v-else class="photo-grid">
                    <div v-for="filename in photos" :key="filename" class="photo-item" @click="openModal(filename)">
                        <img :src="`http://localhost:3000/uploads/${filename}`" class="photo-img" />
                        <v-btn v-if="!isPublicView" icon size="x-small" class="photo-action-btn delete-btn"
                            color="error" @click.stop="deletePhoto(filename)">
                            <v-icon size="12">mdi-close</v-icon>
                        </v-btn>
                        <v-btn v-if="isPublicView" icon size="x-small" class="photo-action-btn report-btn"
                            color="warning" @click.stop="reportPhoto(filename)">
                            <v-icon size="12">mdi-flag</v-icon>
                        </v-btn>
                    </div>
                </div>
            </div>

            <v-btn v-if="!isPublicView" block color="error" variant="flat" class="logout-btn" @click="logout">
                <v-icon start>mdi-logout</v-icon> Logout
            </v-btn>

        </v-container>
    </div>

    <!-- Modal fullscreen -->
    <v-dialog v-model="modal" max-width="90vw">
        <v-card style="background:black; display:flex; align-items:center; justify-content:center; padding:8px; position:relative;">
            <v-btn icon variant="text" color="white" style="position:absolute; top:8px; right:8px; z-index:1;"
                @click="modal = false">
                <v-icon>mdi-close</v-icon>
            </v-btn>
            <img :src="`http://localhost:3000/uploads/${modalSrc}`"
                style="max-width:100%; max-height:85vh; object-fit:contain; border-radius:8px;" />
        </v-card>
    </v-dialog>

    <!-- Snackbar feedback -->
    <v-snackbar v-model="snackbar" :color="snackbarColor" timeout="2500" location="bottom">
        {{ snackbarMsg }}
    </v-snackbar>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';
import { useRouter, useRoute } from 'vue-router';

const router = useRouter();
const route = useRoute();
const token = localStorage.getItem('token');
const headers = { Authorization: `Bearer ${token}` };

const isPublicView = computed(() => !!route.params.userId);
const user = ref({});
const photos = computed(() => Array.isArray(user.value.photos) ? user.value.photos : []);
const photoInput = ref(null);
const modal = ref(false);
const modalSrc = ref('');
const snackbar = ref(false);
const snackbarMsg = ref('');
const snackbarColor = ref('success');

const showSnack = (msg, color = 'success') => {
    snackbarMsg.value = msg;
    snackbarColor.value = color;
    snackbar.value = true;
};

const loadUser = async () => {
    try {
        if (isPublicView.value) {
            const res = await axios.get(`http://localhost:3000/api/auth/user/${route.params.userId}/profile`, { headers });
            if (res.data.success) user.value = res.data.user;
        } else {
            const res = await axios.get('http://localhost:3000/api/auth/user', { headers });
            if (res.data.success) user.value = res.data.user;
        }
    } catch (e) {
        console.error('Erro ao carregar user:', e);
    }
};

const triggerPhotoInput = () => photoInput.value?.click();

const uploadPhoto = async (event) => {
    const file = event.target.files[0];
    if (!file) return;
    const formData = new FormData();
    formData.append('photo', file);
    try {
        const res = await axios.post('http://localhost:3000/api/auth/user/photos', formData, {
            headers: { ...headers, 'Content-Type': 'multipart/form-data' }
        });
        if (res.data.success) { user.value.photos = res.data.photos; showSnack('Foto adicionada!'); }
    } catch (e) {
        console.error('Erro ao enviar foto:', e);
    }
};

const deletePhoto = async (filename) => {
    try {
        const res = await axios.delete(`http://localhost:3000/api/auth/user/photos/${filename}`, { headers });
        if (res.data.success) { user.value.photos = res.data.photos; showSnack('Foto removida.'); }
    } catch (e) {
        console.error('Erro ao apagar foto:', e);
    }
};

const reportPhoto = async (filename) => {
    try {
        await axios.post(`http://localhost:3000/api/auth/user/${route.params.userId}/report`, { filename }, { headers });
        showSnack('Foto reportada.', 'warning');
    } catch (e) {
        console.error('Erro ao reportar:', e);
    }
};

const openModal = (filename) => { modalSrc.value = filename; modal.value = true; };
const logout = () => { localStorage.removeItem('token'); router.push('/login'); };

onMounted(() => loadUser());
</script>

<style scoped>
.page-bg { background-color: #f0f2f5; min-height: 100vh; }
.page-container { padding-top: 4vh; }
.section-block { background: white; border-radius: 16px; padding: 20px 24px; border: 1px solid #e8edf5; }
.section-header { display: flex; align-items: center; gap: 8px; }
.section-title { font-size: 1rem; font-weight: 700; color: #1a1a2e; margin: 0; }
.profile-header { display: flex; flex-direction: column; align-items: center; padding: 16px 0; }
.profile-name { font-size: 1.4rem; font-weight: 700; color: #1a1a2e; margin: 0; }
.profile-username { color: #5f6b7a; font-size: 0.9rem; }
.profile-stats { display: flex; align-items: center; gap: 16px; }
.stat { display: flex; flex-direction: column; align-items: center; }
.stat-value { font-size: 1.1rem; font-weight: 700; color: #1a1a2e; }
.stat-label { font-size: 0.75rem; color: #5f6b7a; }
.stat-divider { width: 1px; height: 30px; background: #e8edf5; }
.info-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; }
.info-label { color: #5f6b7a; font-size: 0.9rem; }
.info-value { font-weight: 600; color: #1a1a2e; font-size: 0.9rem; }
.photo-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }
.photo-item { aspect-ratio: 1; overflow: hidden; border-radius: 10px; position: relative; cursor: pointer; }
.photo-img { width: 100%; height: 100%; object-fit: cover; transition: opacity 0.2s; }
.photo-img:hover { opacity: 0.85; }
.photo-action-btn { position: absolute; top: 4px; right: 4px; }
.empty-row { text-align: center; color: #5f6b7a; padding: 16px; font-size: 0.9rem; }
.logout-btn { border-radius: 8px !important; font-weight: 600; height: 44px !important; }
</style>