<template>
    <div class="container-fluid mt-4">
        <h2 class="text-center" style="margin-bottom: 25px">{{resource_name | capitalize}} Manager</h2>
        <b-alert :show="loading" variant="info">Loading...</b-alert>

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
      ...mapActions(['fetchResources', 'userRequest', 'setCurrentResource']),

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

      fetchResources(resource_name, this);
    },

    // https://stackoverflow.com/questions/43461882/update-vuejs-component-on-route-change
    // The reason we have this here is because the ResourceManager receives route update
    async beforeRouteUpdate (to, from, next) {
      console.log("beforeRouteUpdate:", to.path);
      const resource_name = getResourceNameFromPath(to.path);
      this.resource_name = resource_name;

      fetchResources(resource_name, this);
      next();
    },
  }
</script>

<style scoped>

</style>
