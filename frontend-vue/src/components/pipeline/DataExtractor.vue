<template>
    <div style="margin-top: 10px; margin-bottom: 10px;">
        <!-- Form for new resource -->
        <b-card :title="title">
            <form @submit.prevent="saveInstance">
                <b-form-group label="Title" >
                    <b-form-input type="text" v-model="instance.title"></b-form-input>
                </b-form-group>
                <b-form-group label="Regex">
                    <b-form-textarea rows="8" cols="40" v-model="instance.body"></b-form-textarea>
                </b-form-group>
                <b-form-group label="Sample Text">
                    <b-form-textarea rows="8" cols="40" v-model="instance.sample"></b-form-textarea>
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
  import ResourceDynamicForm from '../dashboard/ResourceDynamicForm';


  export default {
    name: "Extractor",
    extends: ResourceDynamicForm,

    computed: {
      title() {
        return this.instance.id ? 'Edit ' + this.resource + ' ID#' + this.instance.id : 'New ' + this.resource;
      }
    },
    data() {
      return {
        resource: "Extractor",

      };
    },

    methods: {
        simple() {
          console.log(JSON.stringify(this.$parent.instance));
        }
    },

    created() {
      this.simple();
    }

  }
</script>

<style scoped>

</style>
