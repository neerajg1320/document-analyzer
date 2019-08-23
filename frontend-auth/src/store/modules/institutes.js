import apiResource from '../../utils/apiResource';

const resource = 'files';

const state = {
    institutes: []
};

const getters = {
    allInstitutes: state => state.institutes
};

const actions = {
    async fetchInstitutes({ rootState, commit }) {
        const { token } = rootState.auth;
        const response = await apiResource.getList(resource, token);
        commit('setInstitutes', response)
        // eslint-disable-next-line
        console.log(response);
    }
};

const mutations = {
    setInstitutes: (state, institutes) => {
        state.institutes = institutes;
    }
}

export default {
    state,
    getters,
    actions,
    mutations
}
