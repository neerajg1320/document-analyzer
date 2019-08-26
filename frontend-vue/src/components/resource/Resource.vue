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
  import { mapActions, mapGetters } from 'vuex';
  
  function prvGetResourceNameFromPath(path) {
    const path_split_array = path.split('/');

    var resource_name = "none";
    if (path_split_array.length > 2) {
      resource_name = path_split_array[2];
    }

    return resource_name;
  }

  function prvFetchResources (resource_name, component) {
    component.loading = true;
    // eslint-disable-next-line
    component.userRequest().then(resp => {
      // console.log(resp);
    });
    const payload = {'resource_name': resource_name};

    component.fetchResources(payload)
        .then(resp => {
          console.log(resp);
        })
        .catch(err => {
          console.error(err);
        });
    component.loading = false;

  };

  export default {
    name: "Resources",
    data () {
      return {
        'resource_name': 'none',
        loading: false,
        model: {
          type: 'Extract',
          parameters: "None"
        }
      }
    },
    computed: mapGetters(['allResources']),
    methods: {
      ...mapActions(['fetchResources', 'addResource', 'updateResource', 'delResource',
                     'userRequest']),

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
        const payload = {
          "resource_name": this.resource_name,
          "instance": this.model
        };

        if (this.model.id) {
          await this.updateResource(payload)
        } else {
          await this.addResource(payload)
        }

        this.resetModel();
      },

      async deleteInstance (id) {
        if (confirm('Are you sure you want to delete?')) {
          const payload = {
            "resource_name": this.resource_name,
            id
          };
          await this.delResource(payload)
        }
      }
    },

    // Resource and Profile have a shared creation code
    async created() {
      console.log("created:", this.$route.path);
      const resource_name = prvGetResourceNameFromPath(this.$route.path);
      this.resource_name = resource_name;
      prvFetchResources(resource_name, this);
    },

    // https://stackoverflow.com/questions/43461882/update-vuejs-component-on-route-change
    async beforeRouteUpdate (to, from, next) {
      console.log("beforeRouteUpdate:", to.path);
      const resource_name = prvGetResourceNameFromPath(to.path);
      this.resource_name = resource_name;
      prvFetchResources(resource_name, this);
      next();
    },
  }
</script>

<style scoped>

</style>
