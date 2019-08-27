<template>
    <div>
        <!-- Form for new resource -->
        <b-card :title="(instance.id ? 'Edit ' + resource + ' ID#' + instance.id : 'New ' + resource )">
            <form @submit.prevent="saveInstance">

                <b-form-group label="Title">
                    <b-form-input type="text" v-model="instance.title"></b-form-input>
                </b-form-group>
                <b-form-group label="Regex">
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
    name: "ResourceSimpleForm",
    data () {
      return {
        instanceInitState: {
          type: 'Extract',
          parameters: "None"
        },
        instance: {},
        resource: ''
      }
    },

    computed: {
      ...mapGetters(['currentResource', 'currentInstance']),
    },

    methods: {
      ...mapActions(['addResource', 'updateResource']),

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

    watch: {
      currentInstance(newValue, oldValue) {
        // eslint-disable-next-line
        console.log(`Updating instance to  ${newValue.id} from ${oldValue.id}`);

        if ('id' in newValue) {
          this.instance = Object.assign({}, this.currentInstance);
        } else {
          this.resetInstance();
        }
      },

      currentResource(newValue, oldValue) {
        // eslint-disable-next-line
        console.log(`Updating resource to '${newValue}' from '${oldValue}'`);
        this.resource = newValue;
        this.instance  = Object.assign({}, this.instanceInitState);
      },
    },

    created() {
      this.resetInstance();
      this.resource = this.currentResource;
    }
  }
</script>
