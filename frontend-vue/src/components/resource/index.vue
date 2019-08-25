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
                    <a href="#" @click.prevent="deleteInstance(resource.id)">Delete</a>
                </td>
            </tr>
            </tbody>
        </table>

        <div>
            <form @submit.prevent="saveInstance">
                <label label="Title">Title</label>
                <input type="text" v-model="model.title">

                <label label="Body">Body</label>
                <textarea v-model="model.body"></textarea>
                <div>
                    <button type="submit" variant="success">Save Post</button>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
    import {USER_REQUEST} from '../../store/actions/user'
    import { mapActions, mapGetters } from 'vuex';
    const resource_name = 'operations';

    export default {
        name: "Resources",
        data () {
            return {
                model: {
                    type: 'Extract',
                    parameters: "None"
                }
            }
        },
        computed: mapGetters(['allResources']),
        methods: {
            ...mapActions(['fetchResources', 'saveResource', 'delResource']),

            populateResourceToEdit (resource_instance) {
                console.log(resource_instance.id);
                // this.model = Object.assign({}, post)
            },

            saveInstance() {
                console.log(this.model.title, this.model.body);
                const payload = {resource_name, "instance": this.model}
                this.saveResource(payload)
                    .then(resp => {
                      console.log(resp);
                    })
                    .catch(err => {
                      console.log(err);
                    })
            },

            deleteInstance (id) {
                if (confirm('Are you sure you want to delete?')) {
                    // if we are editing a post we deleted, remove it from the form
                    const payload = {resource_name, id};
                    this.delResource(payload)
                        .then(resp => {
                          console.log(resp);
                        })
                        .catch(err => {
                          console.log(err);
                        })
                }
            }
        },
        created() {
          const payload = {resource_name};
          this.fetchResources(payload);
          this.$store.dispatch(USER_REQUEST).then(resp => {
            console.log(resp);
          });
        }
    }
</script>

<style scoped>

</style>
