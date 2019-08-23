<template>
    <div>
        Please wait...
    </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {

    name: "AuthHandler",
    methods: mapActions(['finalizeLogin']), // Connect an action to a component
    created() {
        this.finalizeLogin(window.location.hash);
    }
}
</script>

<style scoped>

</style>