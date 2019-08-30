<template>
    <div style=" width:100%;  padding: 20px; text-align: center;">

        <b-card header-tag="header" style="margin-bottom: 20px; text-align: left; display: inline-flex;">
            <div slot="header" class="mb-0">
                {{card_header}}
                <b-btn type="success" @click="applyOperator" style="float: right;">Apply</b-btn>
            </div>
            <form @submit.prevent="saveInstance">
                <div style="text-align: center; margin-top: 20px;">
                    <b-btn type="submit" variant="success">Save</b-btn>
                    <b-btn type="button" @click.prevent="onCancel" style="margin-left: 10px">Cancel</b-btn>
                    <b-btn type="button" @click.prevent="addToPipeline" style="float: right">Pipeline</b-btn>
                </div>

                <b-form-group label="Title" >
                    <b-form-input type="text" v-model="operator_title"></b-form-input>
                </b-form-group>
                <b-form-group label="Regex">
                    <b-form-textarea rows="8" cols="80" v-model="regex_str"></b-form-textarea>
                </b-form-group>
                <b-form-group v-if="mode && mode == 'studio'" label="Sample Text">
                    <b-form-textarea rows="8" cols="80" v-model="sample_str"></b-form-textarea>
                </b-form-group>
            </form>
        </b-card>

        <!-- This needs to go out of DataExtractor Component -->
        <!-- We are using v-show instead of v-if because we need tabulator in this.$refs -->
        <div v-show="mode && mode == 'studio' && table_data && table_data.length"
             style="display: inline-block; width: 80%;">
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
            <div style="margin-bottom: 20px;"></div>
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
  import tableMixin from '../mixin/TableMixin';
  import dataOperatorMixin from '../mixin/DataOperatorCompMixin';

  import Etrade from '../presets/etrade/Extractor';
  import { mapActions } from  'vuex';

  export default {
    name: "Extractor",
    mixins: [tableMixin, dataOperatorMixin],

    data() {
      return {
        // resource, instance belong to formMixin

        regex_str: "",
        sample_str: "",

        table_data: [],
        schema_table_data: [],

        table_options: {
          autoColumns: true,
          layout: "fitData",
          layoutColumnsOnNewData:true,
          height: "300",
        },

        schema_table_options:  {
          autoColumns: true,
          layout: "fitData",
          layoutColumnsOnNewData:true,
          height: "300",
        },
      };
    },

    methods: {
      ...mapActions(['actionResource', 'addOperationToPipeline']),

      // Called by apply and save operations
      prepareOperatorInstance () {
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

      },

      // Called by apply operation
      getDataFrameArray () {
        return [{'text': this.sample_str}];
      },

      // Need to see if 'this' behaves properly, this is called from callback in applyOperation
      applyOperatorCompleted(resp) {
        console.log(resp);
        this.table_data = resp.transactions;
        this.schema_table_data = resp.schema;
      },
    },

    created() {
      console.log('DataExtractorRegex.created:', JSON.stringify(this.instance));
      this.operator_title = "EVE"
      this.operator_type = "Extractor"

      if (this.mode && this.mode == 'studio') {
        this.regex_str = Etrade.regex_str;
        this.sample_str = Etrade.sample_str;
      }
    },

  }
</script>

<style scoped>

</style>
