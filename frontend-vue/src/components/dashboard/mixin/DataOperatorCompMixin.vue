<script>
  import resourceCompMixin from './ResourceCompMixin'

  export default {
    props: ['mode'],
    mixins: [resourceCompMixin],

    computed: {
      card_header () {
        return this.instance.id ? this.operator_type + ' ID#' + this.instance.id : 'New ' + this.operator_type;
      }
    },

    data () {
      return {
        operator_type: "None",
        operator_title: "Untitled",
      };
    },

    methods: {
      addToPipeline () {
        this.prepareOperatorInstance();
        this.addOperationToPipeline(this.instance)
          .then(resp => {
            console.log(resp);
          })
      },

      // This is called by saveInstance from the FormMixin
      beforeSave () {
        this.prepareOperatorInstance();
      },

      afterSave (saved_instance) {

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

        const $this = this;
        this.actionResource(payload)
          .then(resp => {
            $this.applyOperatorCompleted(resp);
          });
      },
    },

    created () {
      console.log('DataOperatorCompMixin.created:');

      // This line has to be here as it sets the resource in formMixin
      this.resource = "operations"
    }
  }
</script>
