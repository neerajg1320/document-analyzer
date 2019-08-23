<template>
    <div class="ui secondary pointing menu">
        <router-link to="/" class="item active">
            Image Storage
        </router-link>

        <div class="right menu">
            <div v-if="isLoggedIn" class="horizontal">
                <!--
                <a class="item">Galleries</a>
                <a class="item">Upload</a>
                -->
                <router-link to="/" class="item">Galleries</router-link>
                <router-link to="/upload" class="item">Upload</router-link>
                <a class="item" @click="logout">Logout</a>
            </div>
            <a v-else href="#" class="ui item" @click="login">
                Login
            </a>
        </div>
    </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';

export default {
    name: "AppHeader",
    computed: mapGetters(['isLoggedIn']), // Connect getters from vuex to a component
    methods: mapActions(['login', 'logout']) // Connect actions from vuex to a component
}
</script>

<style scoped>
.horizontal {
    display: flex;
    flex-direction: row;
}
</style>