import api from '../../api/imgur';
import { router } from '../../main';

const state = {
    images: []
};

const getters = {
    allImages: state => state.images
};

const actions = {
    async fetchImages({ rootState, commit }) {
        const { token } = rootState.auth;
        const response = await api.fetchImages(token);
        commit('setImages', response.data.data);
    },

    async uploadImages({ rootState, commit }, images) {
        // Get the access token
        const { token } = rootState.auth;

        // Call the imgur api module for upload
        await api.uploadImages(images, token);

        // Redirect the user to some other page to manifest the upload like ImageList
        // Navigate the user to other page without hard reload
        router.push('/');
    }
};

const mutations = {
    setImages: (state, images) => {
        state.images = images;
    }
};

export default {
    state,
    getters,
    actions,
    mutations
};