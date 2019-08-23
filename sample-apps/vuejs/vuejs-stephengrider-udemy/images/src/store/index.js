import Vuex from 'vuex';
import Vue from 'vue';
import auth from './modules/auth';
import images from './modules/images';


// Connection between Vue and Vuex. We are telling Vue to use Vuex as a middleware.
Vue.use(Vuex);

export default new Vuex.Store({
    modules: {
        // auth: auth
        auth,  //This wires auth module to our Vuex instance
        images
    }
});