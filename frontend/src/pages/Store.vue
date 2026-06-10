<template>
  <v-main>
    <v-container class="py-8" max-width="900">

      <div class="d-flex align-center justify-space-between mb-6">
        <div>
          <h1 class="text-h5 font-weight-bold">Loja de Coupons</h1>
          <p class="text-medium-emphasis text-body-2 mt-1">Troca os teus pontos por descontos exclusivos</p>
        </div>
        <v-chip color="primary" size="large" prepend-icon="mdi-star">
          {{ store.user?.points ?? 0 }} pontos
        </v-chip>
      </div>

      <v-tabs v-model="tab" class="mb-6">
        <v-tab value="loja">Loja</v-tab>
        <v-tab value="meus">
          Os Meus Coupons
          <v-badge v-if="myCoupons.length" :content="myCoupons.length" color="primary" inline class="ml-1" />
        </v-tab>
      </v-tabs>

      <v-tabs-window v-model="tab">

        <v-tabs-window-item value="loja">
          <v-progress-linear v-if="loadingCoupons" indeterminate class="mb-4" />

          <v-alert v-if="errorMsg" type="error" class="mb-4" closable @click:close="errorMsg = ''">
            {{ errorMsg }}
          </v-alert>
          <v-alert v-if="successMsg" type="success" class="mb-4" closable @click:close="successMsg = ''">
            {{ successMsg }}
          </v-alert>

          <v-row v-if="!loadingCoupons">
            <v-col v-for="coupon in coupons" :key="coupon.id" cols="12" sm="6" md="4">
              <v-card variant="outlined" class="h-100">
                <v-card-item>
                  <v-card-title class="text-body-1 font-weight-bold">{{ coupon.title }}</v-card-title>
                  <v-card-subtitle class="text-caption">{{ coupon.description }}</v-card-subtitle>
                </v-card-item>

                <v-card-text>
                  <div class="d-flex align-center justify-space-between">
                    <v-chip color="success" size="small" variant="tonal">
                      {{ coupon.discount }} desconto
                    </v-chip>
                    <span class="text-caption text-medium-emphasis">
                      {{ coupon.stock === -1 ? 'Ilimitado' : coupon.stock + ' restantes' }}
                    </span>
                  </div>
                </v-card-text>

                <v-divider />

                <v-card-actions class="pa-3">
                  <v-chip prepend-icon="mdi-star" size="small" color="primary" variant="tonal">
                    {{ coupon.points_cost }} pts
                  </v-chip>
                  <v-spacer />
                  <v-btn
                    color="primary"
                    variant="flat"
                    size="small"
                    :disabled="(store.user?.points ?? 0) < coupon.points_cost || coupon.stock === 0 || buying === coupon.id"
                    :loading="buying === coupon.id"
                    @click="buy(coupon)"
                  >
                    Comprar
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-col>

            <v-col v-if="coupons.length === 0" cols="12">
              <v-empty-state
                icon="mdi-tag-off-outline"
                title="Nenhum coupon disponível"
                text="Volta mais tarde, novos coupons são adicionados regularmente."
              />
            </v-col>
          </v-row>
        </v-tabs-window-item>

        <v-tabs-window-item value="meus">
          <v-progress-linear v-if="loadingMy" indeterminate class="mb-4" />

          <v-list v-if="!loadingMy && myCoupons.length">
            <v-list-item
              v-for="uc in myCoupons"
              :key="uc.id"
              :title="uc.coupon?.title"
              :subtitle="uc.coupon?.description"
              class="mb-2"
              rounded="lg"
              border
            >
              <template #append>
                <div class="text-right">
                  <v-chip color="primary" variant="tonal" size="small" class="mb-1 font-weight-bold">
                    {{ uc.code }}
                  </v-chip>
                  <div class="text-caption text-medium-emphasis">
                    {{ formatDate(uc.purchased_at) }}
                  </div>
                </div>
              </template>
            </v-list-item>
          </v-list>

          <v-empty-state
            v-if="!loadingMy && myCoupons.length === 0"
            icon="mdi-ticket-outline"
            title="Ainda não tens coupons"
            text="Vai à loja e troca os teus pontos!"
          />
        </v-tabs-window-item>

      </v-tabs-window>
    </v-container>
  </v-main>
</template>

<script>
import Navbar from '../components/Navbar.vue';
import { useAppStore } from '../stores/store.js';
import api from '../api/axios.js';

export default {
  components: { Navbar },
  setup() {
    const store = useAppStore();
    return { store };
  },
  data() {
    return {
      tab: 'loja',
      coupons: [],
      myCoupons: [],
      loadingCoupons: false,
      loadingMy: false,
      buying: null,
      errorMsg: '',
      successMsg: ''
    };
  },
  watch: {
    tab(val) {
      if (val === 'meus') this.fetchMyCoupons();
    }
  },
  async mounted() {
    await this.fetchUser();
    this.fetchCoupons();
  },
  methods: {
    async fetchUser() {
      try {
        const res = await api.get('/auth/user');
        this.store.user = res.data.user;
      } catch {}
    },
    async fetchCoupons() {
      this.loadingCoupons = true;
      try {
        const res = await api.get('/auth/store/coupons');
        this.coupons = res.data.coupons;
      } catch (e) {
        this.errorMsg = e.response?.data?.message || 'Erro ao carregar coupons.';
      } finally {
        this.loadingCoupons = false;
      }
    },
    async fetchMyCoupons() {
      this.loadingMy = true;
      try {
        const res = await api.get('/auth/store/my-coupons');
        this.myCoupons = res.data.coupons;
      } catch (e) {
        this.errorMsg = e.response?.data?.message || 'Erro ao carregar os teus coupons.';
      } finally {
        this.loadingMy = false;
      }
    },
    async buy(coupon) {
      this.buying = coupon.id;
      this.errorMsg = '';
      this.successMsg = '';
      try {
        const res = await api.post(`/auth/store/coupons/${coupon.id}/buy`);
        this.successMsg = `Coupon obtido! O teu código: ${res.data.code}`;
        if (this.store.user) this.store.user.points -= coupon.points_cost;
        await this.fetchCoupons();
      } catch (e) {
        this.errorMsg = e.response?.data?.message || 'Erro ao comprar coupon.';
      } finally {
        this.buying = null;
      }
    },
    formatDate(d) {
      return new Date(d).toLocaleDateString('pt-PT', { day: '2-digit', month: 'short', year: 'numeric' });
    }
  }
};
</script>   