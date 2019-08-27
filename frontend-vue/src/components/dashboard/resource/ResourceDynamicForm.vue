<template>
    <div>
        <!-- Form for new resource -->
        <b-card :title="(instance.id ? 'Edit ' + resource + ' ID#' + instance.id : 'New ' + resource )">
            <form @submit.prevent="saveInstance">

                <b-form-group label="Title">
                    <b-form-input type="text" v-model="instance.title"></b-form-input>
                </b-form-group>
                <b-form-group label="Type">
                    <b-form-textarea rows="4" v-model="instance.type"></b-form-textarea>
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
  import formMixin from '../mixin/FormMixin';

  export default {
    name: "ResourceDynamicForm",
    mixins: [formMixin],

    computed: {
      ...mapGetters(['currentResource', 'currentInstance']),
    },

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

    methods: {
      ...mapActions(['addResource', 'updateResource']),

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
  }
</script>
