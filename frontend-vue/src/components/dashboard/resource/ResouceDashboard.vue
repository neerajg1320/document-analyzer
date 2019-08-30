<template>
    <div class="container-fluid mt-4" style="border: dotted;">
        <h2 class="text-center" style="margin-bottom: 25px">{{resource | capitalize}} Manager</h2>
        <b-row>
            <b-col lg="6">
                <ResourceList></ResourceList>
            </b-col>
            <b-col lg="6">
                <ResourceDynamicForm></ResourceDynamicForm>
                <!--<ResourceSimpleForm></ResourceSimpleForm>-->
            </b-col>
        </b-row>
    </div>
</template>

<script>
  import { mapActions } from 'vuex';
  import ResourceList from './ResourceList';
  import ResourceDynamicForm from './ResourceDemuxComp'
  import ResourceSimpleForm from './ResourceSimpleForm'
  import path from '../../../utils/path';


  export default {
    name: "Dashboard",

    components: {
      // ResourceSimpleForm,
      ResourceDynamicForm,
      ResourceList
    },

    data () {
      return {
        resource: 'none'
      }
    },

    methods: {
      ...mapActions(['setCurrentResource']),

      loadResource(resource) {
        this.resource = resource
        const payload = { resource };
        this.setCurrentResource(payload);
      }
    },

    // Resource and Profile have a shared creation code
    async created() {
      // eslint-disable-next-line
      console.log("created:", this.$route.path);
      this.loadResource(path.getResourceFromPath(this.$route.path));
    },

    // https://stackoverflow.com/questions/43461882/update-vuejs-component-on-route-change
    // The reason we have this here is because the ResourceManager receives route update
    async beforeRouteUpdate (to, from, next) {
      // eslint-disable-next-line
      console.log("beforeRouteUpdate:", to.path);
      this.loadResource(path.getResourceFromPath(to.path));
      next();
    },
  }
</script>

<style scoped>

</style>
