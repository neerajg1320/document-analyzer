<template>
    <div>
        <!-- List of Operations -->
        <h2>Operations</h2>
        <table class="table table-striped">
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
    import { mapActions, mapGetters } from 'vuex';

    export default {
        name: "Resources",
        computed: mapGetters(['allResources']),
        methods: {
            ...mapActions(['fetchResources']),

            populateResourceToEdit (resource) {
                console.log(resource.id);
                // this.model = Object.assign({}, post)
            },

            deleteResource (id) {
                console.log(id);
                if (confirm('Are you sure you want to delete?')) {
                    // if we are editing a post we deleted, remove it from the form
                }
            }
        },
        created() {
            const resource = 'operations';
            this.fetchResources(resource);
        }
    }
</script>

<style scoped>

</style>
