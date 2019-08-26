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
            <tr v-for="resource in allInstances" :key="resource.id">
                <td>{{ resource.id }}</td>
                <td>{{ resource.title }}</td>
                <td>{{ resource.type }}</td>
                <td class="text-right">
                    <a href="#" @click.prevent="selectResource(resource)">Edit</a> -
                    <a href="#" @click.prevent="deleteInstance(resource.id)">Delete</a>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';

  export default {
    name: "ResourceList",
    props: ['resource'],
    computed: mapGetters(['allInstances']),
    methods: {
      ...mapActions(['setCurrentResource', 'delResource']),
      selectResource(instance) {
        const payload = {
          'resource': this.resource,
          instance
        };
        this.setCurrentResource(payload);
      },

      async addInstance() {
        const payload = {
          "resource_name": this.resource,
          "instance": this.currentInstance
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
            "resource_name": this.resource,
            id
          };
          await this.delResource(payload)
        }
      }
    }
  }
</script>

<style scoped>

</style>
