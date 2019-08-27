export default {
  watch: {
    currentInstance (newValue, oldValue) {
      // eslint-disable-next-line
      console.log(`Updating instance to  ${newValue.id} from ${oldValue.id}`);

      if ('id' in newValue) {
        this.instance = Object.assign({}, this.currentInstance);
      } else {
        this.resetInstance();
      }
    },

    currentResource (newValue, oldValue) {
      // eslint-disable-next-line
      console.log(`Updating resource to '${newValue}' from '${oldValue}'`);
      this.resource = newValue;
      this.instance  = Object.assign({}, this.instanceInitState);
    },
  },

  methods: {
    resetInstance() {
      this.instance = Object.assign({}, this.instanceInitState);
    },

    onCancel() {
      this.resetInstance();
    },
  },

  created() {
    this.resetInstance();
    this.resource = this.currentResource;
  },
}
