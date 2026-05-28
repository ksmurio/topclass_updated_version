<template>
    <div class="page-bg">
        <v-container class="page-container">
            <v-row class="mb-4">
                <v-col>
                    <div style="display:flex; align-items:center; gap:8px;">
                        <v-btn icon variant="text" @click="$router.back()">
                            <v-icon>mdi-arrow-left</v-icon>
                        </v-btn>
                        <div>
                            <h1 class="page-title">Community</h1>
                            <p class="page-sub">Talk with your club members</p>
                        </div>
                    </div>
                </v-col>
            </v-row>

            <div class="section-block mb-4">
                <div class="new-post-area">
                    <v-avatar size="36" color="#1A73E8">
                        <v-icon color="white" size="20">mdi-account</v-icon>
                    </v-avatar>
                    <v-textarea v-model="newPostContent" placeholder="Share something with the club..."
                        variant="outlined" rows="2" hide-details density="compact" class="post-input" rounded="lg" />
                </div>

                <!-- Preview da imagem selecionada -->
                <div v-if="selectedImagePreview" class="image-preview-area mt-3">
                    <div class="image-preview-wrapper">
                        <img :src="selectedImagePreview" class="image-preview" alt="preview" />
                        <v-btn icon size="x-small" class="remove-image-btn" color="error" @click="removeImage">
                            <v-icon size="14">mdi-close</v-icon>
                        </v-btn>
                    </div>
                </div>

                <div style="display:flex; justify-content:space-between; align-items:center; margin-top:10px;">
                    <!-- Botão de anexar foto -->
                    <v-btn variant="text" size="small" color="#5f6b7a" @click="triggerFileInput">
                        <v-icon size="18" class="mr-1">mdi-image-outline</v-icon>
                        Photo
                    </v-btn>
                    <input ref="fileInput" type="file" accept="image/*" style="display:none" @change="onFileSelected" />

                    <v-btn color="#1A73E8" rounded="lg" size="small"
                        :disabled="!newPostContent.trim()" :loading="posting"
                        @click="createPost">
                        Post
                    </v-btn>
                </div>
            </div>

            <div v-if="posts.length === 0" class="section-block">
                <div class="empty-row">No posts yet. Be the first!</div>
            </div>

            <div v-for="post in posts" :key="post.id" class="section-block mb-3">
                <div class="post-header">
                    <v-avatar size="36" color="#1A73E8">
                        <v-img v-if="post.user?.profile_picture"
                            :src="`http://localhost:3000/uploads/${post.user.profile_picture}`" />
                        <v-icon v-else color="white" size="20">mdi-account</v-icon>
                    </v-avatar>
                    <div>
                        <span class="post-username">{{ post.user?.username }}</span>
                        <span class="post-date">{{ post.created_at?.slice(0, 10) }}</span>
                    </div>
                </div>

                <p class="post-content">{{ post.content }}</p>

                <!-- Imagem do post (se existir) -->
                <div v-if="post.image" class="post-image-area">
                    <img :src="`http://localhost:3000/uploads/${post.image}`" class="post-image" alt="post image"
                        @click="openImageModal(post.image)" />
                </div>

                <div class="post-actions">
                    <v-btn variant="text" size="small" color="#5f6b7a" @click="toggleComments(post.id)">
                        <v-icon size="16" class="mr-1">mdi-comment-outline</v-icon>
                        {{ post.comments?.length || 0 }} comments
                    </v-btn>
                </div>

                <div v-if="openComments[post.id]" class="comments-section">
                    <div v-for="comment in post.comments" :key="comment.id" class="comment-item">
                        <v-avatar size="26" color="#e8edf5">
                            <v-img v-if="comment.user?.profile_picture"
                                :src="`http://localhost:3000/uploads/${comment.user.profile_picture}`" />
                            <v-icon v-else color="white" size="20">mdi-account</v-icon>
                        </v-avatar>
                        <div class="comment-bubble">
                            <span class="comment-username">{{ comment.user?.username }}</span>
                            <span class="comment-text">{{ comment.content }}</span>
                        </div>
                    </div>

                    <div class="new-comment-area">
                        <v-text-field v-model="newComment[post.id]" placeholder="Write a comment..." variant="outlined"
                            density="compact" hide-details rounded="lg" @keyup.enter="createComment(post.id)">
                            <template #append-inner>
                                <v-icon color="#1A73E8" style="cursor:pointer"
                                    @click="createComment(post.id)">mdi-send</v-icon>
                            </template>
                        </v-text-field>
                    </div>
                </div>
            </div>

        </v-container>

        <!-- Modal para ver imagem em fullscreen -->
        <v-dialog v-model="imageModal" max-width="90vw">
            <v-card style="background:black; display:flex; align-items:center; justify-content:center; padding:8px;">
                <v-btn icon variant="text" color="white" style="position:absolute; top:8px; right:8px; z-index:1;"
                    @click="imageModal = false">
                    <v-icon>mdi-close</v-icon>
                </v-btn>
                <img :src="`http://localhost:3000/uploads/${modalImageSrc}`"
                    style="max-width:100%; max-height:85vh; object-fit:contain; border-radius:8px;" />
            </v-card>
        </v-dialog>

    </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue';
import axios from 'axios';
import { useRoute } from 'vue-router';

const route = useRoute();
const clubId = route.params.id;

const posts = ref([]);
const newPostContent = ref('');
const newComment = reactive({});
const openComments = reactive({});
const loading = ref(false);
const error = ref(false);
const posting = ref(false);

// Upload de imagem
const fileInput = ref(null);
const selectedFile = ref(null);
const selectedImagePreview = ref(null);

// Modal fullscreen
const imageModal = ref(false);
const modalImageSrc = ref('');

const token = localStorage.getItem('token');
const headers = { Authorization: `Bearer ${token}` };

const loadPosts = async () => {
    loading.value = true;
    error.value = false;
    try {
        const res = await axios.get(`http://localhost:3000/api/auth/club/${clubId}/community/posts`, { headers });
        if (res.data.success) posts.value = res.data.posts;
    } catch (error) {
        console.error('Error loading posts:', error);
        error.value = true;
    } finally {
        loading.value = false;
    }
};

const triggerFileInput = () => {
    fileInput.value?.click();
};

const onFileSelected = (event) => {
    const file = event.target.files[0];
    if (!file) return;
    selectedFile.value = file;
    selectedImagePreview.value = URL.createObjectURL(file);
};

const removeImage = () => {
    selectedFile.value = null;
    selectedImagePreview.value = null;
    if (fileInput.value) fileInput.value.value = '';
};

const createPost = async () => {
    if (!newPostContent.value.trim()) return;
    posting.value = true;
    try {
        // Usar FormData para suportar envio de ficheiro
        const formData = new FormData();
        formData.append('content', newPostContent.value);
        if (selectedFile.value) {
            formData.append('image', selectedFile.value);
        }

        const res = await axios.post(
            `http://localhost:3000/api/auth/club/${clubId}/community/posts`,
            formData,
            { headers: { ...headers, 'Content-Type': 'multipart/form-data' } }
        );

        if (res.data.success) {
            newPostContent.value = '';
            removeImage();
            await loadPosts();
        }
    } catch (error) {
        console.error('Error creating post:', error);
    } finally {
        posting.value = false;
    }
};

const toggleComments = (postId) => {
    openComments[postId] = !openComments[postId];
};

const createComment = async (postId) => {
    if (!newComment[postId]?.trim()) return;
    try {
        const res = await axios.post(`http://localhost:3000/api/auth/club/${clubId}/community/posts/${postId}/comments`, {
            content: newComment[postId]
        }, { headers });
        if (res.data.success) {
            newComment[postId] = '';
            await loadPosts();
        }
    } catch (e) {
        console.error('Error creating comment:', e);
    }
};

const openImageModal = (imageSrc) => {
    modalImageSrc.value = imageSrc;
    imageModal.value = true;
};

onMounted(() => loadPosts());
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
    margin: 0;
}

.page-sub {
    color: #5f6b7a;
    font-size: 0.9rem;
    margin: 0;
}

.section-block {
    background: white;
    border-radius: 16px;
    padding: 20px 24px;
    border: 1px solid #e8edf5;
}

.new-post-area {
    display: flex;
    gap: 12px;
    align-items: flex-start;
}

.post-input {
    flex: 1;
}

.image-preview-area {
    padding-left: 48px;
}

.image-preview-wrapper {
    position: relative;
    display: inline-block;
}

.image-preview {
    max-width: 260px;
    max-height: 180px;
    object-fit: cover;
    border-radius: 10px;
    border: 1px solid #e8edf5;
    display: block;
}

.remove-image-btn {
    position: absolute;
    top: -6px;
    right: -6px;
}

.post-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 10px;
}

.post-username {
    font-weight: 700;
    color: #1a1a2e;
    font-size: 0.88rem;
    display: block;
}

.post-date {
    font-size: 0.75rem;
    color: #5f6b7a;
}

.post-content {
    color: #1a1a2e;
    font-size: 0.9rem;
    margin: 0 0 10px 0;
    line-height: 1.5;
}

.post-image-area {
    margin-bottom: 10px;
}

.post-image {
    max-width: 100%;
    max-height: 320px;
    object-fit: cover;
    border-radius: 10px;
    border: 1px solid #e8edf5;
    cursor: pointer;
    transition: opacity 0.2s;
}

.post-image:hover {
    opacity: 0.9;
}

.post-actions {
    border-top: 1px solid #f0f2f5;
    padding-top: 8px;
}

.comments-section {
    margin-top: 12px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.comment-item {
    display: flex;
    align-items: flex-start;
    gap: 8px;
}

.comment-bubble {
    background: #f0f2f5;
    border-radius: 12px;
    padding: 8px 12px;
    flex: 1;
}

.comment-username {
    font-weight: 700;
    font-size: 0.78rem;
    color: #1a1a2e;
    display: block;
}

.comment-text {
    font-size: 0.85rem;
    color: #1a1a2e;
}

.new-comment-area {
    margin-top: 4px;
}

.empty-row {
    text-align: center;
    color: #5f6b7a;
    padding: 24px;
    font-size: 0.9rem;
}
</style>