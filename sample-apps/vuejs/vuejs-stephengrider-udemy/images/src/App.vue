<template>
    <div>
        <AppHeader></AppHeader>
        <div class="ui container">
            <!-- Any time VueRouter matches a route, it will put will its component below -->
            <router-view></router-view>
        </div>
    </div>
</template>

<script>
import AppHeader from './components/AppHeader';

export default {
    name: "App",
    components: {
        AppHeader
    }
}
</script>
