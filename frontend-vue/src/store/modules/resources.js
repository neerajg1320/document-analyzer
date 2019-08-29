import apiResource from '../../api/apiResource';
// eslint-disable-next-line
import delayUtil from '../../utils/delayPromise';

const debug = true;

const instanceInitState = {};
const resourceInitState = '';

const state = {
    instanceList: [],
    instance: instanceInitState,
    resource: resourceInitState
};

const getters = {
    allInstances: state => state.instanceList,
    currentInstance: state => state.instance,
    currentResource: state => state.resource
};

const actions = {
    setCurrentResource({commit}, payload) {
        if (debug) {
            console.log(payload);
        }
        const { resource } = payload;
        commit('setCurrentResourceMut', resource);
    },

    setCurrentInstance({commit}, payload) {
        if (debug) {
            console.log(payload);
        }
        const { instance } = payload;
        commit('setCurrentInstanceMut', instance);
    },

    async fetchResources({ rootState, commit }, payload) {
      return new Promise((resolve, reject) => {
        const {token} = rootState.auth;
        const {resource} = payload;
        apiResource.getList(resource, token)
          .then(resp => {
            commit('setResourcesMut', resp);
            resolve(resp)
          });
      });
    },

    async addResource ({ rootState, commit }, payload) {
      return new Promise((resolve, reject) => {
        const {token} = rootState.auth;
        const {resource_name, instance} = payload;

        apiResource.post(resource_name, token, instance)
          .then(resp => {
            commit('addResourceMut', resp);
            resolve(resp);
          });
      });
    },

    async updateResource ({ rootState, commit }, payload) {
      return new Promise((resolve, reject) => {
        const {token} = rootState.auth;
        const {resource_name, instance} = payload;

        apiResource.put(resource_name, token, instance.id, instance)
          .then(resp => {
            commit('updateResourceMut', resp);
            resolve(resp);
          });

      });
    },

    async delResource ({ rootState, commit }, payload) {
      return new Promise((resolve, reject) => {
        const {token} = rootState.auth;
        const {resource_name, id} = payload;
        apiResource.del(resource_name, token, id)
          .then(resp => {
            commit('deleteResourceMut', id);
            resolve(resp);
          });

      });
    },

    async actionResource ({rootState}, payload) {
        const { token } = rootState.auth;
        const {resource_name, action, data} = payload;
        return apiResource.action(resource_name, action, token, data);
    },
};

const mutations = {
    setCurrentResourceMut: (state, resource) => {
        state.resource = resource;
        console.log(state.resource);
    },

    setCurrentInstanceMut: (state, instance) => {
        state.instance = instance;
        console.log(state.instance);
    },

    setResourcesMut: (state, resources) => {
        state.instanceList = resources;
    },
    addResourceMut: (state, resource) => {
        state.instanceList.push(resource);
    },
    updateResourceMut: (state, resource) => {
        state.instanceList = state.instanceList.map(item => {
            if (item.id === resource.id) {
                return resource;
            }
            return item;
        });
    },
    deleteResourceMut: (state, id) => {
        state.instanceList = state.instanceList.filter(item => {
            return item.id != id;
        })
    }
}

export default {
    state,
    getters,
    actions,
    mutations
}
