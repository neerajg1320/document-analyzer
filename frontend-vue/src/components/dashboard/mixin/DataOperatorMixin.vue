<script>
  import formMixin from './FormMixin'

  export default {
    props: ['mode'],
    mixins: [formMixin],

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

    created () {
      console.log('DataOperatorMixin.created:');

      // This line has to be here as it sets the resource in formMixin
      this.resource = "operations"
    }
  }
</script>
