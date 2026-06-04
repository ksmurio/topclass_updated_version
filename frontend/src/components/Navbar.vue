<template>
    <v-navigation-drawer v-model="drawer" app role="navigation" aria-label="navigation menu">
        <v-list>
            <v-list-item title="Home"      aria-label="go to home"      :to="{ path:'/home' }"      link></v-list-item>
            <v-list-item title="Dashboard" aria-label="go to dashboard" :to="{ path:'/dashboard' }" link></v-list-item>
            <v-list-item title="Clubs"     aria-label="go to Clubs"     :to="{ path:'/clubs' }"     link></v-list-item>
            <v-list-item title="Battles"   aria-label="go to battles"   :to="{ path:'/battles' }"   link></v-list-item>
            <v-list-item title="Ranking"   aria-label="go to ranking"   :to="{ path:'/ranking' }"></v-list-item>
            <v-list-item title="My Notes"  aria-label="go to my notes"  :to="{ path:'/mynotes' }"></v-list-item>
            <v-list-item title="Profile"   aria-label="go to profile"   :to="{ path:'/profile' }"></v-list-item>
        </v-list>
    </v-navigation-drawer>

    <v-app-bar app elevation="1" role="banner">
        <img src="/TOPCLASS.png" style="height: 250px; width: auto;" variant="text" role="img" alt=""
            @click.stop="drawer = !drawer" />
    </v-app-bar>
</template>

<script>
export default {
    data() { return { drawer: false } },
    watch: { $route() { this.drawer = false; } }
}
</script>