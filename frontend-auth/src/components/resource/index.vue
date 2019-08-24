<template>
    <div>
        <!-- List of Operations -->
        <h2>Operations</h2>
        <table class="table table-hover">
            <thead>
            <tr>
                <th>Id</th>
                <th>Title</th>
                <th>Type</th>
                <th>&nbsp;</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="resource in allResources" :key="resource.id">
                <td>{{ resource.id }}</td>
                <td>{{ resource.title }}</td>
                <td>{{ resource.type }}</td>
                <td class="text-right">
                    <a href="#" @click.prevent="populateResourceToEdit(resource)">Edit</a> -
                    <a href="#" @click.prevent="deleteResource(resource.id)">Delete</a>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
    import {USER_REQUEST} from '../../store/actions/user'
    import { mapActions, mapGetters } from 'vuex';
    const resource_name = 'operations';

    export default {
        name: "Resources",
        computed: mapGetters(['allResources']),
        methods: {
            ...mapActions(['fetchResources', 'delResource']),

            populateResourceToEdit (instance) {
                console.log(resource.id);
                // this.model = Object.assign({}, post)
            },

            deleteResource (id) {
                if (confirm('Are you sure you want to delete?')) {
                    // if we are editing a post we deleted, remove it from the form
                    const payload = {resource_name, id};
                    this.delResource(payload)
                }
            }
        },
        created() {
            const payload = {resource_name};
            this.fetchResources(payload);
            // this.$store.dispatch(USER_REQUEST, { email, password }).then(() => {
            //     this.$router.push('/')
            // })
        }
    }
</script>

<style scoped>

</style>
