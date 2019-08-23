import api from '../../api/imgur';
import qs from 'qs';
import { router } from '../../main'; // Named import

const state = {
    token: window.localStorage.getItem('imgur_token')
};

const getters = {
    isLoggedIn: (state) => !!state.token
};

const actions = {
    login: () => {
        api.login()
    },
    finalizeLogin: ({ commit }, hash) => {
        const params = qs.parse(hash.replace('#', ''));
        commit('setToken', params.access_token);
        window.localStorage.setItem('imgur_token', params.access_token);

        // Navigate the user to other page without hard reload
        router.push('/');
    },
    logout: ({ commit }) => {
        commit('setToken', null);
        window.localStorage.removeItem('imgur_token');
    }
};

const mutations = {
    setToken: (state, token) => {
        state.token = token;
    }
};


export default {
    state,
    getters,
    actions,
    mutations
}