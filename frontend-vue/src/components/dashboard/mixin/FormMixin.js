import { mapGetters, mapActions } from 'vuex';

export default {
  computed: {
    ...mapGetters(['currentResource', 'currentInstance']),
  },

  data () {
    return {
      instanceInitState: {},
      instance: {},
      resource: ''
    }
  },

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
    ...mapActions(['addResource', 'updateResource']),

    resetInstance() {
      this.instance = Object.assign({}, this.instanceInitState);
    },

    onCancel() {
      this.resetInstance();
    },

    async saveInstance() {
      if (this.beforeSave) {
        this.beforeSave();
      }

      const payload = {
        "resource_name": this.resource,
        "instance": this.instance
      };

      console.log("formMixin:saveInstance");
      console.log(payload);
      if (this.instance.id) {
        await this.updateResource(payload)
      } else {
        await this.addResource(payload)
      }

      this.resetInstance();
    },
  },

  created() {
    this.resetInstance();
    this.resource = this.currentResource;
    console.log(this.resource);
    console.log(this.instance);
  },
}
