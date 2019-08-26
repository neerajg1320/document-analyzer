<template>
    <div>
        <!-- Form for new resource -->
        <b-card :title="(instance.id ? 'Edit ' + currentResource + ' ID#' + instance.id : 'New ' + currentResource )">
            <form @submit.prevent="saveInstance">
                <b-form-group label="Title">
                    <b-form-input type="text" v-model="instance.title"></b-form-input>
                </b-form-group>
                <b-form-group label="Body">
                    <b-form-textarea rows="4" v-model="instance.body"></b-form-textarea>
                </b-form-group>
                <div style="text-align: center">
                    <b-btn type="submit" variant="success">Save</b-btn>
                    <b-btn type="button" @click.prevent="onCancel" style="margin-left: 10px">Cancel</b-btn>
                </div>
            </form>
        </b-card>
    </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';

  export default {
    name: "ResourceDetail",
    data () {
      return {
        instanceInitState: {
          type: 'Extract',
          parameters: "None"
        },
        instance: {}
      }
    },
    computed: mapGetters(['currentResource', 'currentInstance']),

    watch: {
      currentInstance(newValue, oldValue) {
        console.log(`Updating instance to  ${newValue.id} from ${oldValue.id}`);
        this.instance  = Object.assign({}, this.currentInstance);
      },

      currentResource(newValue, oldValue) {
        console.log(`Updating resource to '${newValue}' from '${oldValue}'`);
        this.instance  = Object.assign({}, this.instanceInitState);
      },
    },

    methods: {
      ...mapActions(['addResource', 'updateResource', 'delResource']),

      resetInstance() {
        this.instance = Object.assign({}, this.instanceInitState);
      },

      onCancel() {
        this.resetInstance();
      },

      async saveInstance() {
        const payload = {
          "resource_name": this.currentResource,
          "instance": this.instance
        };

        if (this.instance.id) {
          await this.updateResource(payload)
        } else {
          await this.addResource(payload)
        }

        this.resetInstance();
      },
    },

    created() {
      this.resetInstance();
    }
  }
</script>

<style scoped>

</style>
