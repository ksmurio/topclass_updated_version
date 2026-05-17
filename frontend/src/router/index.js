import { createRouter, createWebHistory } from "vue-router";
import Welcome from "../pages/Welcome.vue";
import Home from "../pages/Home.vue";
import Register from "../pages/Register.vue";
import Login from "../pages/Login.vue";
import Battles from "../pages/Battles.vue";
import Dashboard from "../pages/Dashboard.vue";
import MyNotes from "../pages/MyNotes.vue";
import Profile from "../pages/Profile.vue";
import Ranking from "../pages/Ranking.vue";
import Clubs from "../pages/Clubs.vue";
import CreateClubs from "../pages/CreateClubs.vue";
import club from "../pages/Club.vue";
import AddGrade from "../pages/AddGrade.vue";
import ConfirmacaoEmail from "../pages/ConfirmacaoEmail.vue";
import Community from "../pages/Community.vue";

const routes = [
    {path: '/', name: 'Welcome', component: Welcome},
    {path: '/register', name: 'Register', component: Register},
    {path: '/login', name: 'Login', component: Login},
    {path: '/confirmar-email', name: 'ConfirmacaoEmail', component: ConfirmacaoEmail},
    {path: '/home', name: 'Home', component: Home},
    {path: '/battles', name: 'Battles', component: Battles},
    {path: '/dashboard', name: 'Dashboard', component: Dashboard},
    {path: '/mynotes', name: 'MyNotes', component: MyNotes},
    {path: '/profile', name: 'Profile', component: Profile},
    {path: '/ranking', name: 'Ranking', component: Ranking},
    {path: '/clubs', name: 'Clubs', component: Clubs},
    {path: '/createclubs', name: 'CreateClubs', component: CreateClubs},
    {path: '/club/:id', name: 'club', component: club},
    {path: '/club/:id/community', name: 'Community', component: Community},
    {path: '/AddGrade', name: 'AddGrade', component: AddGrade},
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router;