<template>
    <div style=" width:100%;  padding: 20px; text-align: center;">

        <b-card header-tag="header" style="margin-bottom: 20px; width:60%; text-align: left; display: inline-flex;">
            <div slot="header" class="mb-0">
                {{card_header}}
                <b-btn type="success" @click="applyExtractor" style="float: right;">Apply</b-btn>
            </div>
            <form @submit.prevent="saveInstance">
                <div style="text-align: center; margin-top: 20px;">
                    <b-btn type="submit" variant="success">Save</b-btn>
                    <b-btn type="button" @click.prevent="onCancel" style="margin-left: 10px">Cancel</b-btn>
                </div>

                <b-form-group label="Title" >
                    <b-form-input type="text" v-model="operator_title"></b-form-input>
                </b-form-group>
                <b-form-group label="Regex">
                    <b-form-textarea rows="8" cols="80" v-model="regex_str"></b-form-textarea>
                </b-form-group>
                <b-form-group label="Sample Text">
                    <b-form-textarea rows="8" cols="80" v-model="sample_str"></b-form-textarea>
                </b-form-group>
            </form>
        </b-card>

        <!-- We are using v-show instead of v-if because we need tabulator in this.$refs -->
        <div v-show="table_data && table_data.length"
             style="display: inline-block; width: 60%;">
            <div class="smart-table">
                <VueTable
                    ref="vueTable"
                    v-model="table_data"
                    :options="table_options"
                    :integration="{ updateStrategy: 'SET' }"
                    class="thead-dark">
                </VueTable>
                <div v-if="false" style="padding: 10px;">
                    <b-btn @click="downloadTable($refs.vueTable)" style="float: right; margin-left: 10px;">Download</b-btn>
                    <b-btn @click="uploadTable($refs.vueTable)" style="float: right;">Upload</b-btn>
                </div>
            </div>
        </div>
        <div style="margin-bottom: 20px;"></div>
        <div v-show="table_data && table_data.length"
                style="display: inline-block; width: 60%;">
            <div class="smart-table">
                <VueTable
                    ref="vueSchemaTable"
                    v-model="schema_table_data"
                    :options="schema_table_options"
                    :integration="{ updateStrategy: 'SET' }"
                    class="thead-dark">
                </VueTable>
                <div  v-if="false" style="padding: 10px;">
                    <b-btn @click="downloadTable($refs.vueSchemaTable)" style="float: right; margin-left: 10px;">Download</b-btn>
                    <b-btn @click="uploadTable($refs.vueSchemaTable)" style="float: right;">Upload</b-btn>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
  import formMixin from '../mixin/FormMixin';
  import tableMixin from '../mixin/TableMixin';
  import Etrade from '../presets/etrade/Extractor';
  import { mapActions } from  'vuex';

  export default {
    name: "Extractor",
    mixins: [formMixin, tableMixin],

    computed: {
      card_header () {
        return this.operator_id ? this.operator + ' ID#' + this.operator_id : 'New ' + this.operator;
      }
    },

    data() {
      return {
        // resource, instance belong to formMixin

        operator: "Extractor",

        operator_id: "",
        operator_title: "",
        regex_str: Etrade.regex_str,
        sample_str: Etrade.sample_str,

        table_data: [],
        schema_table_data: [],

        table_options: {
          autoColumns: true,
          layout: "fitWidth",
          layoutColumnsOnNewData:true,
          height: "300",
        },

        schema_table_options:  {
          autoColumns: true,
          layout: "fitWidth",
          layoutColumnsOnNewData:true,
          height: "300",
        },
      };
    },

    methods: {
      ...mapActions(['actionResource']),

      prepareExtractorInstance () {
        const extractor_parameters = {
          type: "regex",
          parameters: {
            regex: this.regex_str
          }
        }
        // We should assign the instance here
        this.instance = {
          title: this.operator_title,
          type: "Extract",
          parameters: JSON.stringify(extractor_parameters)
        }

        if (this.operator_id) {
          this.instance.id = this.operator_id;
        }
      },

      getDataFrameArray () {
        return [{'text': this.sample_str}];
      },

      applyExtractor () {
        this.prepareExtractorInstance();
        const dataframeArray = this.getDataFrameArray();

        const payload = {
          action: "apply",
          resource_name: this.resource,
          data: {
            "operation_params": JSON.stringify(this.instance),
            "dataframe_json": JSON.stringify(dataframeArray)
          },
        }

        this.actionResource(payload)
          .then(resp => {
            this.table_data = resp.transactions;
            this.schema_table_data = resp.schema;
          });

      },

      // This is called by saveInstance from the FormMixin
      beforeSave () {
        this.prepareTransformerInstance();
      },

      // Note the extractor id has to be updated after save
      afterSave() {

      },
    },

    created() {
      // This line has to be here as it sets the resource in formMixin
      this.resource = "operations"
    },

  }
</script>

<style scoped>

</style>
