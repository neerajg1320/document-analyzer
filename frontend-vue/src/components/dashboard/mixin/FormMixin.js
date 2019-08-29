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

  methods: {
    ...mapActions(['addResource', 'updateResource', 'setCurrentInstance']),

    assignInstance (dstInstance) {
      this.instance = Object.assign({}, dstInstance);
    },

    resetInstance () {
      this.assignInstance(this.instanceInitState);
    },

    onCancel() {
      this.resetInstance();
      const payload = { instance: this.instance };
      this.setCurrentInstance(payload);
    },

    async saveInstance() {
      if (this.beforeSave) {
        this.beforeSave();
      }

      const payload = {
        "resource_name": this.resource,
        "instance": this.instance
      };

      console.log("formMixin:saveInstance", payload);

      var resp = {};
      if (this.instance.id) {
        resp = await this.updateResource(payload);
      } else {
        resp = await this.addResource(payload);
      }

      if (this.afterSave) {
        this.afterSave(resp);
      }

      this.resetInstance();
    },
  },

  watch: {
    currentInstance (newValue, oldValue) {
      // eslint-disable-next-line
      console.log(`Updating instance to  ${newValue.id} from ${oldValue.id}`);

      if ('id' in newValue) {
        this.assignInstance(this.currentInstance);
      } else {
        this.resetInstance();
      }
    },

    currentResource (newValue, oldValue) {
      // eslint-disable-next-line
      console.log(`Updating resource to '${newValue}' from '${oldValue}'`);
      this.resource = newValue;
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
