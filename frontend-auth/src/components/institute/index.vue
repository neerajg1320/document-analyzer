<template>
    <div>
        <h2>Institute List</h2>
        <h3 v-for="institute in allResources" :key="institute.id">{{ institute.title }}</h3>
    </div>
</template>

<script>
    import { mapActions, mapGetters } from 'vuex';

    export default {
        name: "Institutes",
        computed: mapGetters(['allResources']),
        methods: mapActions(['fetchResources']),
        created() {
            const resource = 'operations';
            this.fetchResources(resource);
        }
    }
</script>

<style scoped>

</style>
