import apiResource from '../../utils/apiResource';

const state = {
    resources: []
};

const getters = {
    allResources: state => state.resources
};

const actions = {
    async fetchResources({ rootState, commit }, payload) {
        // console.log('fetchResources:', payload);
        const { token } = rootState.auth;
        const { resource_name } = payload;
        const response = await apiResource.getList(resource_name, token);
        commit('setResources', response)
    },
    async delResource ({ rootState, commit }, payload) {
        const { token } = rootState.auth;
        const {resource_name, id} = payload;
        const response = await apiResource.del(resource_name, token, id);
    },
};

const mutations = {
    setResources: (state, resources) => {
        state.resources = resources;
    }
}

export default {
    state,
    getters,
    actions,
    mutations
}
