<template>
    <div class="container-fluid mt-4">
        <h2 class="text-center" style="margin-bottom: 25px">{{resource | capitalize}} Manager</h2>
        <b-row>
            <b-col>
                <ResourceList></ResourceList>
            </b-col>
            <b-col lg="5">
                <ResourceDetail></ResourceDetail>
            </b-col>
        </b-row>
    </div>
</template>

<script>
  import { mapActions } from 'vuex';
  import ResourceDetail from './ResourceDetail';
  import ResourceList from './ResourceList';
  import path from '../../utils/path';

  export default {
    name: "Dashboard",

    components: {
      ResourceDetail,
      ResourceList
    },

    data () {
      return {
        resource: 'none'
      }
    },

    methods: {
      ...mapActions(['userRequest', 'setCurrentResource']),

    },

    // Resource and Profile have a shared creation code
    async created() {
      console.log("created:", this.$route.path);

      this.userRequest();

      this.resource = path.getResourceFromPath(this.$route.path);
      const payload = { 'resource': this.resource };
      this.setCurrentResource(payload);
    },

    // https://stackoverflow.com/questions/43461882/update-vuejs-component-on-route-change
    // The reason we have this here is because the ResourceManager receives route update
    async beforeRouteUpdate (to, from, next) {
      console.log("beforeRouteUpdate:", to.path);

      this.resource = path.getResourceFromPath(to.path);
      const payload = { 'resource': this.resource };
      this.setCurrentResource(payload);

      next();
    },
  }
</script>

<style scoped>

</style>
