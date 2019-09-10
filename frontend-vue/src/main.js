import Vue from 'vue';
import App from './App';
import router from './router/Router';
import store from './store/Store';

import Loading from './components/lib/loading'
import CenterContainer from './components/lib/center-container'
Vue.component('loading', Loading);
Vue.component('center-container', CenterContainer);

import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
Vue.use(BootstrapVue);

import VueTabulator from 'vue-tabulator';
Vue.use(VueTabulator, {
    name: 'VueTable'
});

Vue.filter('capitalize', function (value) {
    if (!value) return ''
    value = value.toString()
    return value.charAt(0).toUpperCase() + value.slice(1)
});
Vue.filter('singularize', function (value) {
    if (!value) return ''
    value = value.toString()
    return value.slice(0, -1);
});

new Vue({
    router,
    store,
    render: h => h(App)
}).$mount('#app')
