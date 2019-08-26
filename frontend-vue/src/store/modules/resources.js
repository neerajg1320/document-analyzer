import apiResource from '../../utils/apiResource';
// eslint-disable-next-line
import delayUtil from '../../utils/delayPromise';

const debug = true;

const state = {
    resources: []
};

const getters = {
    allResources: state => state.resources
};

const actions = {
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
    setResourcesMut: (state, resources) => {
        state.resources = resources;
    },
    addResourceMut: (state, resource) => {
        state.resources.push(resource);
    },
    updateResourceMut: (state, resource) => {
        state.resources = state.resources.map(item => {
            if (item.id === resource.id) {
                return resource;
            }
            return item;
        });
    },
    deleteResourceMut: (state, id) => {
        state.resources = state.resources.filter(item => {
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
