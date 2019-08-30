<template>
    <div style=" width:100%;  padding: 20px; text-align: center;">

        <!-- We are using v-show instead of v-if because we need ref vueInputTable in this.$refs -->
        <div v-show="mode && mode == 'studio'"  style="display: inline-block; width: 80%;">
            <div class="smart-table">
                <VueTable
                    ref="vueInputTable"
                    v-model="table_data"
                    :options="table_options"
                    :integration="{ updateStrategy: 'SET' }"
                    class="thead-dark">
                </VueTable>
                <div style="padding: 10px;">
                    <b-btn @click="uploadTable($refs.vueInputTable)" style="float: right;">Upload</b-btn>
                </div>
            </div>
            <div style="margin-bottom: 40px;"></div>
            <div class="smart-table">
                <VueTable
                    ref="vueSchemaTable"
                    v-model="schema_table_data"
                    :options="table_options"
                    :integration="{ updateStrategy: 'SET' }"
                    class="thead-dark">
                </VueTable>
                <div style="padding: 10px;">
                    <b-btn @click="uploadTable($refs.vueSchemaTable)" style="float: right;">Upload</b-btn>
                </div>
            </div>
            <div style="margin-bottom: 40px;"></div>
        </div>


        <b-card header-tag="header" style="width:80%; text-align: left; display: inline-flex;">
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

                <div style="width: 40%;">
                    <b-form-group label="Title" >
                        <b-form-input type="text" v-model="operator_title"></b-form-input>
                    </b-form-group>

                    <b-form-group label="Schema" >
                        <b-form-select v-model="selected" :options="options"></b-form-select>
                    </b-form-group>
                </div>
            </form>

            <div style="margin-bottom: 40px;"></div>
            <div style="text-align: center;">
                <div class="smart-table">
                    <VueTable
                        ref="vueMapperTable"
                        v-model="mapper_table_data"
                        :options="mapper_table_options"
                        :integration="{ updateStrategy: 'SET' }"
                        class="thead-dark">
                    </VueTable>
                    <div style="padding: 10px;">
                        <b-btn @click="downloadTable($refs.vueMapperTable)" style="float: right; margin-left: 10px;">Download</b-btn>
                        <b-btn @click="uploadTable($refs.vueMapperTable)" style="float: right;">Upload</b-btn>
                    </div>
                </div>
                <div style="margin-bottom: 40px;"></div>
                <div class="smart-table">
                    <VueTable
                        ref="vueNewFieldsTable"
                        v-model="newfields_table_data"
                        :options="newfields_table_options"
                        :integration="{ updateStrategy: 'SET' }"
                        class="thead-dark">
                    </VueTable>
                    <div style="padding: 10px;">
                        <b-btn @click="addEmptyRow(newfields_table_data)" style="float: left;">Add</b-btn>
                        <b-btn @click="downloadTable($refs.vueNewFieldsTable)" style="float: right; margin-left: 10px;">Download</b-btn>
                        <b-btn @click="uploadTable($refs.vueNewFieldsTable)" style="float: right;">Upload</b-btn>
                    </div>
                </div>
            </div>
        </b-card>

        <div v-show="mode && mode == 'studio' && mapped_table_data && mapped_table_data.length" class="smart-table">
            <div style="margin-bottom: 40px;"></div>
            <VueTable
                ref="vueOutputTable"
                v-model="mapped_table_data"
                :options="mapped_table_options"
                :integration="{ updateStrategy: 'SET' }"
                class="thead-dark">
            </VueTable>
            <div style="padding: 10px;">
                <b-btn @click="downloadTable($refs.vueOutputTable)" style="float: right; margin-left: 10px;">Download</b-btn>
            </div>
        </div>
    </div>
</template>

<script>
  import formMixin from '../mixin/FormMixin';
  import tableMixin from '../mixin/TableMixin';
  import dataOperatorMixin from '../mixin/DataOperatorMixin';

  import Trades from '../presets/etrade/Transformer';
  import { mapActions } from  'vuex';

  let temp_mapper_type_edit_check = function(cell){
    //get row data
    let row = cell.getRow().getData();

    return row.mapping == "SPLIT_SEP" || row.mapping == "SPLIT_REGEX_STATIC"; // only allow the name cell to be edited if the age is over 18
  }

  let temp_column_name_edit_check = function(cell){
    //get row data
    let row = cell.getRow().getData();

    return row.type == "Generate-Temp" || row.type == "Generate-Regex"; // only allow the name cell to be edited if the age is over 18
  }

  export default {
    name: "Transformer",
    mixins: [formMixin, tableMixin, dataOperatorMixin],

    computed: {
      card_header () {
        return this.operator_id ? this.operator + ' ID#' + this.operator_id : 'New ' + this.operator;
      }
    },

    data() {
      return {
        // resource, instance belong to formMixin

        operator: "Transformer",
        operator_id: "",
        operator_title: "EVT",

        selected: '2',
        options: [
              { value: null, text: 'Please select a Schema' },
              { value: '2', text: 'Contract Note' },
              { value: '11', text: 'Bank Statement' },
        ],

        table_data: [],
        schema_table_data: [],
        mapper_table_data: [],
        newfields_table_data: [],
        mapped_table_data: [],

        table_options: {
          autoColumns: true,
          layout: "fitWidth",
          layoutColumnsOnNewData:true,
          height: "300",
        },

        mapper_table_options: {
          layout: "fitWidth",
          layoutColumnsOnNewData:true,
          height: "300",
          movableRows: true,

          columns:[
            {title:"SourceColumn", field:"src"},
            {title:"SourceColumnType", field:"srctype"},

            {title:"Mapping", field:"mapping", editor:"select", editorParams: function(cell) {
                let values = {
                  "IGNORE": "IGNORE",
                  "RENAME": "RENAME",
                  "SPLIT_SEP": "SPLIT_SEP",
                  "SPLIT_REGEX_STATIC": "SPLIT_REGEX_STATIC",
                  "SPLIT_REGEX_DYNAMIC": "SPLIT_REGEX_DYNAMIC",
                };

                return {"values": values};
              }
            },
            {title:"DestinationColumn", field:"dst", editor:"select", editorParams: function(cell) {
                let row = cell.getRow().getData();
                console.log(row.mapping);

                const values = {"None": "None"};
                if (row.mapping != "IGNORE") {

                  console.log(g_table_schema_dict);
                  let destination_table = $("#sel-destination-schema").val();
                  console.log(destination_table);
                  let dynamic_fields_array = g_table_schema_dict[destination_table].fields_json;
                  console.log(dynamic_fields_array);

                  let fields_array = JSON.parse(dynamic_fields_array);
                  let destination_fields = fields_array.map(a => a.name);

                  destination_fields.forEach(function (field_name) {
                      values[field_name] = field_name;
                    }
                  );
                }

                return {"values": values};
              }
            },
            {title:"Parameters", field:"parameters", editor:"input", editable: temp_mapper_type_edit_check},
          ],
        },

        newfields_table_options : {
          layout: "fitWidth",
          layoutColumnsOnNewData: true,
          height: "300",
          movableRows: true,

          columns:[
            {title:"Active", field:"active", editor:"tick", formatter:"tick", editable:true},
            {title:"Rule-Type", field:"type", editor:"select", editable:true, editorParams: function(cell) {
                console.log(cell.getRow().getData());

                values = {};
                values["Generate-Temp"] = "Generate-Temp";
                values["Generate-Final"] = "Generate-Final";
                values["Generate-Regex"] = "Generate-Regex";

                return {"values": values};
              }
            },
            {title:"SrcColumn", field:"src", editor:"select", editorParams: function(cell) {
                let row = cell.getRow().getData();
                console.log(row);

                const values = {};
                if (row.type == "Generate-Regex") {
                  let src_fields_array = g_document_mapper_table.getData("json");

                  // Create a list of unassigned fields
                  console.log(src_fields_array);
                  src_fields_array.forEach(function (src_field) {
                      if (src_field.mapping == "SPLIT_REGEX_DYNAMIC") {
                        values[src_field.src] = src_field.src;
                      }
                    }
                  );
                }

                return {"values": values};
              }
            },
            {title:"TempColumn", field:"temp_name", editor:"input", editable: temp_column_name_edit_check},
            {title:"SchemaColumn", field:"dst", editor:"select", editorParams: function(cell) {
                let row = cell.getRow().getData();
                console.log(row);

                const values = {};
                if (row.type == "Generate-Final") {
                  let destination_table = $("#sel-destination-schema").val();

                  let fields_array = JSON.parse(g_table_schema_dict[destination_table].fields_json);
                  let destination_fields = fields_array.map(a => a.name);

                  // Find list of fields already assigned
                  let mapper_array = g_document_mapper_table.getData("json");
                  let assigned_field_set = new Set(mapper_array.map(a => a.dst));

                  // Create a list of unassigned fields

                  destination_fields.forEach(function (field_name) {
                      if (!assigned_field_set.has(field_name))
                        values[field_name] = field_name;
                    }
                  );
                }

                return {"values": values};
              }
            },
            {title:"Value", field:"value", editor:"input", editable:true},
            {title:"Delete", formatter:"buttonCross", width:40, align:"center", cellClick:function(e, cell){
                cell.getRow().delete();
              }
            },
          ],
        },

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

        const newfieldsTableJson = this.getTableJson(this.$refs.vueNewFieldsTable);
        newfieldsTableJson.forEach(row => row['value'] = row['value'].replace(/\\/g, "\\\\"));

        // We need three fields destination_table, existing_fields, new_fields
        const transformer_parameters = {
          destination_table: this.selected,
          existing_fields: JSON.stringify(this.getTableJson(this.$refs.vueMapperTable)),
          new_fields: JSON.stringify(newfieldsTableJson),
        };

        // We should assign the instance here
        this.instance = {
          title: this.operator_title,
          type: "Transform",
          parameters: JSON.stringify(transformer_parameters)
        };

        if (this.operator_id) {
          this.instance.id = this.operator_id;
        }
      },

      getDataFrameArray () {
        return this.getTableJson(this.$refs.vueInputTable);
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
            this.mapped_table_data = JSON.parse(resp.mapped_df_json);
          });

      },

      // This is called by saveInstance from the FormMixin
      beforeSave () {
        this.prepareOperatorInstance();
      },

      afterSave (instance) {
        this.operator_id = instance.id;
      },

    },



    created() {
      console.log('DataTransformer.created:', JSON.stringify(this.instance));

      // This line has to be here as it sets the resource in formMixin
      this.resource = "operations"
      this.table_data = JSON.parse(Trades.raw_trades);
      this.schema_table_data = JSON.parse(Trades.raw_trades_schema);

      this.mapper_table_data = JSON.parse(Trades.existing_fields_mapper_table);
      // this.mapper_table_data.forEach(row => row['mapping'] = "RENAME");
      this.newfields_table_data = JSON.parse(Trades.newfields_transformer_table);

    },

  }
</script>

<style scoped>

</style>
