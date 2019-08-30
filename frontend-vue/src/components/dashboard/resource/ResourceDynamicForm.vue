<template>
    <div>
        <!-- Form for new resource -->
        <b-card  :title="(instance.id ? 'Edit ' + resource + ' ID#' + instance.id : 'New ' + resource )">
            <form @submit.prevent="saveInstance">

                <b-form-group label="Title">
                    <b-form-input type="text" v-model="instance.title"></b-form-input>
                </b-form-group>
                <b-form-group label="Type">
                    <b-form-input type="text" v-model="instance.type"></b-form-input>
                </b-form-group>
                <b-form-group label="Parameters">
                    <b-form-textarea rows="4" v-model="instance.parameters"></b-form-textarea>
                </b-form-group>

                <div style="text-align: center">
                    <b-btn type="submit" variant="success">Save</b-btn>
                    <b-btn type="button" @click.prevent="onCancel" style="margin-left: 10px">Cancel</b-btn>
                </div>
            </form>
        </b-card>

        <div v-if="currentResource == 'operations'">
            <DataExtractorRegex></DataExtractorRegex>
        </div>
    </div>
</template>

<script>
  import { mapGetters } from 'vuex';
  import formMixin from '../mixin/FormMixin';
  import DataExtractorRegex from '../pipeline/DataExtractorRegex';

  export default {
    name: "ResourceDynamicForm",
    mixins: [formMixin],
    components: { DataExtractorRegex },

    computed: {
      ...mapGetters(['currentResource']),

    },

  }
</script>
