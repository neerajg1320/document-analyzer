<template>
    <div>
        <!-- List of Operations -->
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
                    <a href="#" @click.prevent="deleteInstance(resource.id)">Delete</a>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
  import { mapGetters } from 'vuex';


  export default {
    name: "ResourceList",
    computed: mapGetters(['allResources']),

  }
</script>

<style scoped>

</style>
