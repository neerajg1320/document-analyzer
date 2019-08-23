<template>
    <div>
        <h2>Institute List</h2>
        <h3 v-for="institute in allInstitutes" :key="institute.id">{{ institute.title }}</h3>
    </div>
</template>

<script>
    import { mapActions, mapGetters } from 'vuex';

    export default {
        name: "Institutes",
        computed: mapGetters(['allInstitutes']),
        methods: mapActions(['fetchInstitutes']),
        created() {
            this.fetchInstitutes();
        }
    }
</script>

<style scoped>

</style>
