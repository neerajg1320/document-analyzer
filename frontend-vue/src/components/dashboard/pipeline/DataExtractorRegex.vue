<template>
    <div style="margin-top: 10px; margin-bottom: 10px;">
        <!-- Form for new resource -->
        <b-card header-tag="header" >
            <div slot="header" class="mb-0">
                {{card_header}}
                <b-btn type="success" @click="apply" style="float: right;">Apply</b-btn>
            </div>
            <form @submit.prevent="saveInstance">
                <div style="text-align: center; margin-top: 20px;">
                    <b-btn type="submit" variant="success">Save</b-btn>
                    <b-btn type="button" @click.prevent="onCancel" style="margin-left: 10px">Cancel</b-btn>
                </div>

                <b-form-group label="Title" >
                    <b-form-input type="text" v-model="extractor_title"></b-form-input>
                </b-form-group>
                <b-form-group label="Regex">
                    <b-form-textarea rows="8" cols="80" v-model="regex_str"></b-form-textarea>
                </b-form-group>
                <b-form-group label="Sample Text">
                    <b-form-textarea rows="8" cols="80" v-model="sample_str"></b-form-textarea>
                </b-form-group>
                <VueTable
                        ref="tabulator"
                        v-model="table_data"
                        :options="table_options"
                        :integration="{ updateStrategy: 'REPLACE' }" >
                </VueTable>

            </form>
        </b-card>
    </div>
</template>

<script>
  import formMixin from '../mixin/FormMixin';

  export default {
    name: "Extractor",
    mixins: [formMixin],

    computed: {
      card_header () {
        return this.extractor_id ? this.operator + ' ID#' + this.extractor_id : 'New ' + this.operator;
      }
    },

    data() {
      return {
        operator: "Extractor",

        extractor_id:"",
        extractor_title: "",
        regex_str:"",
        sample_str:"",

        table_data: [
          {id:1, value:100},
          {id:2, value:200}
        ],

        table_options: {
          autoColumns: true,
          layout: "fitColumns"

          // columns: [
          //   {
          //     title: 'ID',
          //     field: 'id',
          //     // width: 200,
          //     // editor: true,
          //   },
          //   {
          //     title: 'Value',
          //     field: 'value',
          //     sorter: 'string',
          //     // width: 200,
          //     editor: true,
          //   },
          // ],
        }
      };
    },

    methods: {
      apply () {
        console.log(this.instance);
      },

      // This is called by saveInstance from the FormMixin
      beforeSave () {
        const extractor_parameters = {
          type: "regex",
          parameters: {
            regex: this.regex_str
          }
        }
        // We should assign the instance here
        this.instance = {
          title: this.extractor_title,
          type: "Extract",
          parameters: JSON.stringify(extractor_parameters)
        }

        if (this.extractor_id) {
          this.instance.id = this.extractor_id;
        }
      },
    },

    // Note the extractor id has to be updated after save
    afterSave() {

    },

    created() {
      // This line has to be here as it sets the resource in formMixin
      this.resource = "operations"
    }
  }
</script>

<style scoped>

</style>
