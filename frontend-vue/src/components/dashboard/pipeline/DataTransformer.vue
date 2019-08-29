<template>
    <div style=" width:100%;  padding: 20px; text-align: center;">
        <!-- We are using v-show instead of v-if because we need tabulator in this.$refs -->
        <div v-show="false" style="display: inline-block; width: 80%;">
            <VueTable
                    ref="vueTable"
                    v-model="table_data"
                    :options="table_options"
                    :integration="{ updateStrategy: 'SET' }"
                    class="thead-dark">
            </VueTable>
        </div>

        <div v-show="false"  style="display: inline-block; width: 80%;">
            <VueTable
                    ref="vueSchemaTable"
                    v-model="schema_table_data"
                    :options="table_options"
                    :integration="{ updateStrategy: 'SET' }"
                    class="thead-dark">
            </VueTable>
        </div>

        <b-card header-tag="header" style="margin-bottom: 20px; width:80%; text-align: left; display: inline-flex;">
            <div slot="header" class="mb-0">
                {{card_header}}
                <b-btn type="success" @click="applyTransformer" style="float: right;">Apply</b-btn>
            </div>
            <form @submit.prevent="saveInstance">
                <div style="text-align: center; margin-top: 20px;">
                    <b-btn type="submit" variant="success">Save</b-btn>
                    <b-btn type="button" @click.prevent="onCancel" style="margin-left: 10px">Cancel</b-btn>
                </div>

                <b-form-group label="Title" >
                    <b-form-input type="text" v-model="transformer_title"></b-form-input>
                </b-form-group>

            </form>
            <div style="margin-bottom: 40px;"></div>
            <div>
                <VueTable
                        ref="vueMapperTable"
                        v-model="mapper_table_data"
                        :options="mapper_table_options"
                        :integration="{ updateStrategy: 'SET' }"
                        class="thead-dark">
                </VueTable>
                <div style="margin-bottom: 40px;"></div>
                <VueTable
                        ref="vueNewFieldsTable"
                        v-model="newfields_table_data"
                        :options="newfields_table_options"
                        :integration="{ updateStrategy: 'SET' }"
                        class="thead-dark">
                </VueTable>
                <b-btn @click="addEmptyRow(newfields_table_data)" style="margin-top: 10px;">Add</b-btn>
            </div>
        </b-card>

    </div>
</template>

<script>
  import formMixin from '../mixin/FormMixin';
  import tableMixin from '../mixin/TableMixin';
  import Trades from '../presets/etrade/Trades';
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
    mixins: [formMixin, tableMixin],

    computed: {
      card_header () {
        return this.transformer_id ? this.operator + ' ID#' + this.transformer_id : 'New ' + this.operator;
      }
    },

    data() {
      return {
        // resource, instance belong to formMixin

        operator: "Transformer",
        transformer_id: "",
        transformer_title: "",

        table_ref: "",

        table_data: [],
        schema_table_data: [],
        mapper_table_data: [],
        newfields_table_data: [
          {"type": "", "temp_name": "", "dst": "", "value":"None"}
        ],

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
        }


      };
    },

    downloadTable () {

    },

    methods: {
      ...mapActions(['actionResource']),

      addRowNewFieldTable (table_data) {
        table_data.push({});
      },

      prepareTransformerInstance () {
        const transformer_parameters = {
          type: "regex",
          parameters: {
            regex: this.regex_str
          }
        }
        // We should assign the instance here
        this.instance = {
          title: this.transformer_title,
          type: "Transform",
          parameters: JSON.stringify(transformer_parameters)
        }

        if (this.transformer_id) {
          this.instance.id = this.transformer_id;
        }
      },

      prepareDataFrameArray () {
        return [{'text': this.sample_str}];
      },

      applyTransformer () {
        this.prepareTransformerInstance();
        const dataframeArray = this.prepareDataFrameArray();

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
            this.table_ref = this.$refs.vueTable;
          });

      },

      // This is called by saveInstance from the FormMixin
      beforeSave () {
        this.prepareTransformerInstance();
      },

      downloadTable () {
        if (this.table_ref) {
          const tabulatorInstance = this.table_ref.getInstance();
          tabulatorInstance.download("json", "table.json");
        }
      }
    },

    // Note the transformer id has to be updated after save
    afterSave() {

    },

    created() {
      // This line has to be here as it sets the resource in formMixin
      this.resource = "operations"
      this.table_data = JSON.parse(Trades.raw_trades);
      this.schema_table_data = JSON.parse(Trades.raw_trades_schema);
      this.mapper_table_data = this.schema_table_data;
      this.mapper_table_data.forEach(row => row['mapping'] = "RENAME");
    },

  }
</script>

<style scoped>

</style>
