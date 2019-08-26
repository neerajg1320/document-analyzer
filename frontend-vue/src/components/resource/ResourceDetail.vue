<template>
    <div>
        <!-- Form for new resource -->
        <b-card :title="(instance.id ? 'Edit ' + resource + ' ID#' + instance.id : 'New ' + resource )">
            <form @submit.prevent="addInstance">
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
        instance: {}
      }
    },
    computed: mapGetters(['currentInstance']),
    props: ['resource'],

    watch: {
        currentInstance(newValue, oldValue) {
          console.log(`Updating to  ${newValue.id} from ${oldValue.id}`);
          this.instance  = Object.assign({}, this.currentInstance);
        }
    },

    methods: {
      ...mapActions(['addResource', 'updateResource', 'delResource']),

      resetInstance() {
        this.instance = {
          type: 'Extract',
          parameters: "None"
        };
      },

      onCancel() {
        this.resetInstance();
      },

      async addInstance() {
        const payload = {
          "resource_name": this.resource,
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
      console.log(this.$route.path);
      this.resetInstance();
    }
  }
</script>

<style scoped>

</style>
