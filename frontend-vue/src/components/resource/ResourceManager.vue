<template>
    <div class="container-fluid mt-4">
        <h2 class="text-center" style="margin-bottom: 25px">{{resource_name | capitalize}} Manager</h2>
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
                    <tr v-for="resource in allInstances" :key="resource.id">
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
                <b-card :title="(model.id ? 'Edit ' + resource_name + ' ID#' + model.id : 'New ' + resource_name )">
                    <form @submit.prevent="addInstance">
                        <b-form-group label="Title">
                            <b-form-input type="text" v-model="model.title"></b-form-input>
                        </b-form-group>
                        <b-form-group label="Body">
                            <b-form-textarea rows="4" v-model="model.body"></b-form-textarea>
                        </b-form-group>
                        <div style="text-align: center">
                            <b-btn type="submit" variant="success">Save</b-btn>
                            <b-btn type="button" @click.prevent="onCancel" style="margin-left: 10px">Cancel</b-btn>
                        </div>
                    </form>
                </b-card>
            </b-col>
        </b-row>
        <b-row>
            <b-col>
                <ResourceList :resource="resource_name"></ResourceList>
            </b-col>
            <b-col lg="5">
                <ResourceDetail></ResourceDetail>
            </b-col>
        </b-row>
    </div>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex';
  import ResourceDetail from './ResourceDetail';
  import ResourceList from './ResourceList';

  function getResourceNameFromPath(path) {
    const path_split_array = path.split('/');

    var resource_name = "none";
    if (path_split_array.length > 2) {
      resource_name = path_split_array[2];
    }

    return resource_name;
  };

  function fetchResources (resource, component) {
    const payload = { resource };
    component.setCurrentResource(payload);

    component.loading = true;
    // eslint-disable-next-line
    component.userRequest().then(resp => {
      // console.log(resp);
    });

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
    components: {ResourceDetail, ResourceList},
    data () {
      return {
        'resource_name': 'none',
        loading: false,
        instance: {}
      }
    },
    computed: mapGetters(['allInstances']),

    methods: {
      ...mapActions(['fetchResources', 'addResource', 'updateResource', 'delResource',
                     'userRequest', 'setCurrentResource']),

      resetInstance() {
        this.model = {
          type: 'Extract',
          parameters: "None"
        };
      },

      populateResourceToEdit (resource_instance) {
        this.model = Object.assign({}, resource_instance)
      },

      onCancel() {
        this.resetInstance();
      },

      async addInstance() {
        const payload = {
          "resource_name": this.resource_name,
          "instance": this.instance
        };

        if (this.instance.id) {
          await this.updateResource(payload)
        } else {
          await this.addResource(payload)
        }

        this.resetInstance();
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

    filters: {
      capitalize: function (value) {
        if (!value) return ''
        value = value.toString()
        return value.charAt(0).toUpperCase() + value.slice(1)
      }
    },

    // Resource and Profile have a shared creation code
    async created() {
      console.log("created:", this.$route.path);
      const resource_name = getResourceNameFromPath(this.$route.path);
      this.resource_name = resource_name;
      this.resetInstance();
      fetchResources(resource_name, this);
    },

    // https://stackoverflow.com/questions/43461882/update-vuejs-component-on-route-change
    // The reason we have this here is because the ResourceManager receives route update
    async beforeRouteUpdate (to, from, next) {
      console.log("beforeRouteUpdate:", to.path);
      const resource_name = getResourceNameFromPath(to.path);
      this.resource_name = resource_name;
      this.resetInstance();
      fetchResources(resource_name, this);
      next();
    },
  }
</script>

<style scoped>

</style>
