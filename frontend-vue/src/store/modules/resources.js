import apiResource from '../../utils/apiResource';
// eslint-disable-next-line
import delayUtil from '../../utils/delayPromise';

const debug = true;

const state = {
    instanceList: [],
    instance: {},
    resource: ''
};

const getters = {
    allInstances: state => state.instanceList,
    currentInstance: state => state.instance
};

const actions = {
    setCurrentInstance({commit}, payload) {
        console.log(payload);
        const { resource, instance } = payload;
        commit('setCurrentInstanceMut', {resource, instance});
    },

    async fetchResources({ rootState, commit }, payload) {
        // This is asynchronous wait
        // delayUtil.delayPromise(5000, "hello")
        //     .then(resp => {
        //         console.log("Delay completed: ", resp);
        //     });

        // The following in synchronous wait
        // await delayUtil.delayPromise(5000);

        const { token } = rootState.auth;
        const { resource_name } = payload;
        const response = await apiResource.getList(resource_name, token);
        commit('setResourcesMut', response)
        if (debug) {
            console.log(response);
        }
    },

    async addResource ({ rootState, commit }, payload) {
        // await delayUtil.delayPromise(5000);

        const { token } = rootState.auth;
        const {resource_name, instance} = payload;

        const resource = await apiResource.post(resource_name, token, instance);
        commit('addResourceMut', resource);
        return resource;
    },

    async updateResource ({ rootState, commit }, payload) {
        const { token } = rootState.auth;
        const {resource_name, instance} = payload;

        const resource = await apiResource.put(resource_name, token, instance.id, instance);
        commit('updateResourceMut', resource);
    },

    async delResource ({ rootState, commit }, payload) {
        const { token } = rootState.auth;
        const {resource_name, id} = payload;
        await apiResource.del(resource_name, token, id);
        commit('deleteResourceMut', id);
    },
};

const mutations = {
    setCurrentInstanceMut: (state, {resource, instance}) => {
        state.resource = resource;
        state.instance = instance;
        console.log(state.resource);
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
