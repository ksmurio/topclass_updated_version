<template>
  <footer class="footer">
    <v-container class="footer-inner">
      <v-row align="center" justify="space-between" no-gutters>

        <v-col cols="12" sm="4" class="d-flex align-center gap-2 mb-3 mb-sm-0">
          <img src="/TOPCLASS(2).png" alt="TopClass" style="height:100px; width:auto; " />
        </v-col>

        <v-col cols="12" sm="4" class="d-flex flex-column justify-center gap-4 mb-3 mb-sm-0">
          <router-link to="/home"      class="footer-link">Home</router-link>
          <router-link to="/dashboard" class="footer-link">Dashboard</router-link>
          <router-link to="/clubs"     class="footer-link">Clubs</router-link>
          <router-link to="/battles"   class="footer-link">Battles</router-link>
        </v-col>

        <v-col cols="12" sm="4" class="text-sm-right text-center">
          <span class="footer-copy">© {{ year }} TopClass. All rights reserved.</span>
        </v-col>

      </v-row>
    </v-container>
  </footer>
</template>

<script setup>
const year = new Date().getFullYear()
</script>

<style scoped>
.footer {
  background: #1A73E8;
  padding: 12px 0;
  width: 100%;
}
.footer-inner { max-width: 1200px; }
.footer-link {
  color: rgba(255,255,255,0.85);
  text-decoration: none;
  font-size: 0.85rem;
  transition: color 0.2s;
}
.footer-link:hover { color: #fff; }
.footer-copy {
  font-size: 0.78rem;
  color: rgba(255,255,255,0.7);
}
</style>