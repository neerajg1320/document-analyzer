<template>
    <div>

        <div v-if="instance.type == 'Extract'">
            <DataExtractorRegex></DataExtractorRegex>
        </div>
        <div v-if="instance.type == 'Transform'">
            <DataTransformer></DataTransformer>
        </div>
        <div v-if="instance.type == 'Load'">
            <DataLoader></DataLoader>
        </div>

        <!-- Form for new resource -->
        <b-card v-if="this.resource != 'operations'" :title="(instance.id ? 'Edit ' + resource + ' ID#' + instance.id : 'New ' + resource )">
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
    </div>
</template>

<script>
  import { mapGetters } from 'vuex';
  import formMixin from '../mixin/ResourceCompMixin';
  import DataExtractorRegex from '../pipeline/DataExtractorRegex';
  import DataTransformer from '../pipeline/DataTransformer';
  import DataLoader from '../pipeline/DataLoader';

  export default {
    name: "ResourceDynamicForm",
    mixins: [formMixin],
    components: { DataExtractorRegex, DataTransformer, DataLoader },

    computed: {
      ...mapGetters(['currentResource']),

    },

  }
</script>
