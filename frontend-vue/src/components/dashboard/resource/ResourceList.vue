<template>
    <div>
        <b-alert :show="loading" variant="info">Loading...</b-alert>
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
                    <a href="#" @click.prevent="selectInstance(resource)">Edit</a> -
                    <a href="#" @click.prevent="confirmDeleteInstance(resource.id)">Delete</a>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';
  import path from '../../../utils/path';

  export default {
    name: "ResourceList",
    computed: mapGetters(['currentResource', 'currentInstance', 'allInstances']),

    data () {
      return {
        loading: false
      };
    },

    methods: {
      ...mapActions(['fetchResources', 'setCurrentInstance', 'delResource']),

      selectInstance(instance) {
        const payload = { instance };
        this.setCurrentInstance(payload);
      },

      async confirmDeleteInstance (id) {
        if (confirm('Are you sure you want to delete?')) {
          const payload = {
            "resource_name": this.resource,
            id
          };
          await this.delResource(payload)

          console.log(this.currentInstance.id);
          if (('id' in this.currentInstance) && (this.currentInstance.id == id))
          {
            this.setCurrentInstance({'instance': {}});
          }
        }
      },

      async loadResource(resource) {
        this.resource = resource;
        this.loading = true;
        const payload = { resource };
        this.fetchResources(payload);
        this.loading = false;
      }
    },

    watch: {
      currentResource(newResource, oldResource) {
        // eslint-disable-next-line
        console.log(`Updating resource to '${newResource}' from '${oldResource}'`);

        this.loadResource(newResource)
      },
    },

    created() {
      const resource = path.getResourceFromPath(this.$route.path);
      this.loadResource(resource);
    }
  }

</script>

<style scoped>

</style>
