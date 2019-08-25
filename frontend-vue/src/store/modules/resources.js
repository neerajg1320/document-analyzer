import apiResource from '../../utils/apiResource';
import delayUtil from '../../utils/delayPromise';

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

        console.log('fetchResources:', payload);
        const { token } = rootState.auth;
        const { resource_name } = payload;
        const response = await apiResource.getList(resource_name, token);
        commit('setResources', response)
    },

    async saveResource ({ rootState, commit }, payload) {
        const { token } = rootState.auth;
        const {resource_name, instance} = payload;
        console.log(resource_name, instance);
        const resource = await apiResource.post(resource_name, token, instance);
        commit('addResource', resource);

    },

    async delResource ({ rootState, commit }, payload) {
        const { token } = rootState.auth;
        const {resource_name, id} = payload;
        await apiResource.del(resource_name, token, id);
        commit('deleteResource', id);
    },
};

const mutations = {
    setResources: (state, resources) => {
        state.resources = resources;
    },
    addResource: (state, resource) => {
        state.resources.push(resource);
    },
    deleteResource: (state, id) => {
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
