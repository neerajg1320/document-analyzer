<template>
    <div style=" width:100%;  padding: 20px; text-align: center;">
        <div v-show="mode && mode == 'studio'">
            <div class="smart-table">
                <VueTable
                    ref="vueMappedTable"
                    v-model="mapped_table_data"
                    :options="mapped_table_options"
                    :integration="{ updateStrategy: 'SET' }"
                    class="thead-dark">
                </VueTable>
                <div style="padding: 10px;">
                    <b-btn @click="uploadTable($refs.vueMappedTable)" style="float: right;">Upload</b-btn>
                </div>
            </div>
            <div style="margin-bottom: 40px;"></div>
        </div>

        <b-card header-tag="header" style="margin-bottom: 20px; width:60%; text-align: left; display: inline-flex;">
            <div slot="header" class="mb-0">
                {{card_header}}
                <b-btn type="success" @click="applyOperator" style="float: right;">Apply</b-btn>
            </div>
            <form @submit.prevent="saveInstance">
                <b-form-group label="Title" >
                    <b-form-input type="text" v-model="operator_title"></b-form-input>
                </b-form-group>
                <b-form-group label="Table" >
                    <b-form-input type="text" v-model="datastore_table"></b-form-input>
                </b-form-group>
                <b-form-group label="Datastore" >
                    <b-form-select v-model="selected" :options="options"></b-form-select>
                </b-form-group>
                <div style="text-align: center; margin-top: 20px;">
                    <b-btn type="submit" variant="success">Save</b-btn>
                    <b-btn type="button" @click.prevent="onCancel" style="margin-left: 10px">Cancel</b-btn>
                    <b-btn type="button" @click.prevent="addToPipeline" style="float: right">Pipeline</b-btn>
                </div>
            </form>
        </b-card>
    </div>
</template>

<script>
  import tableMixin from '../mixin/TableMixin';
  import dataOperatorMixin from '../mixin/DataOperatorCompMixin';

  import { mapActions } from 'vuex';
  import Trades from '../presets/etrade/Loader';

  export default {
    name: "Loader",
    mixins: [tableMixin, dataOperatorMixin],

    data() {
      return {
        // resource, instance belong to formMixin
        datastore_table: "",

        selected: null,
        options: [
          { value: null, text: 'Please select a Datastore' },
          { value: '4', text: 'Local Postgres' },
        ],

        mapped_table_data: [],
        mapped_table_options: {
          autoColumns: true,
          layout: "fitWidth",
          layoutColumnsOnNewData:true,
        },
      };
    },

    methods: {
      ...mapActions(['actionResource', 'addOperationToPipeline']),

      addToPipeline () {
        this.prepareOperatorInstance();
        this.addOperationToPipeline(this.instance)
          .then(resp => {
            console.log(resp);
          })
      },

      prepareOperatorInstance () {

        // We need three fields destination_table, existing_fields, new_fields
        const loader_parameters = {
          table: this.datastore_table,
          datastore_id: this.selected,
        };

        // We should assign the instance here
        this.instance = {
          title: this.operator_title,
          type: "Load",
          parameters: JSON.stringify(loader_parameters)
        };

      },

      getDataFrameArray () {
        return this.getTableJson(this.$refs.vueMappedTable);
      },

      applyOperator () {
        this.prepareOperatorInstance();
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
            console.log(resp);

          });

      },
      
    },

    created() {
      console.log('DataLoader.created:', JSON.stringify(this.instance));

      this.operator_title = "EVL";
      this.operator_type = "Loader";

        // This line has to be here as it sets the resource in formMixin
      if (this.mode && this.mode == 'studio') {
        this.datastore_table = "Trades";
        this.selected = '4';
        this.mapped_table_data = JSON.parse(Trades.mapped_trades);
      }
    },
  }
</script>

<style scoped>

</style>
