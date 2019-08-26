<template>
    <div class="container-fluid mt-4">
        <h2 class="text-center" style="margin-bottom: 25px">Resource Manager</h2>
        <b-alert :show="loading" variant="info">Loading...</b-alert>
        <b-row>
            <b-col>
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
            </b-col>
            <b-col lg="5">
                <!-- Form for new resource -->
                <b-card :title="(model.id ? 'Edit Resource ID#' + model.id : 'New Resource')">
                    <form @submit.prevent="addInstance">
                        <b-form-group label="Title">
                            <b-form-input type="text" v-model="model.title"></b-form-input>
                        </b-form-group>
                        <b-form-group label="Body">
                            <b-form-textarea rows="4" v-model="model.body"></b-form-textarea>
                        </b-form-group>
                        <div>
                            <b-btn type="submit" variant="success">Save</b-btn>
                        </div>
                    </form>
                </b-card>
            </b-col>
        </b-row>
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
        loading: false,
        model: {
          type: 'Extract',
          parameters: "None"
        }
      }
    },
    computed: mapGetters(['allResources']),
    methods: {
      ...mapActions(['fetchResources', 'addResource', 'updateResource', 'delResource']),

      populateResourceToEdit (resource_instance) {
        // eslint-disable-next-line
        // console.log(resource_instance.id);

        this.model = Object.assign({}, resource_instance)
      },

      resetModel() {
        this.model.title = '';
        this.model.body = '';
      },

      async addInstance() {
        const payload = {resource_name, "instance": this.model}

        if (this.model.id) {
          await this.updateResource(payload)
        } else {
          await this.addResource(payload)
        }

        this.resetModel();
      },

      async deleteInstance (id) {
        if (confirm('Are you sure you want to delete?')) {
          const payload = {resource_name, id};
          await this.delResource(payload)
        }
      }
    },

    async created() {
      this.loading = true;
      // eslint-disable-next-line
      this.$store.dispatch(USER_REQUEST).then(resp => {
        // console.log(resp);
      });
      const payload = {resource_name};

      await this.fetchResources(payload);
      this.loading = false;
    }
  }
</script>

<style scoped>

</style>
