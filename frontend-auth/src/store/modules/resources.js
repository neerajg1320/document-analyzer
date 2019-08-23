import apiResource from '../../utils/apiResource';

const state = {
    resources: []
};

const getters = {
    allResources: state => state.resources
};

const actions = {
    async fetchResources({ rootState, commit }, resource_name) {
        const { token } = rootState.auth;
        const response = await apiResource.getList(resource_name, token);
        commit('setResources', response)
    }
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
