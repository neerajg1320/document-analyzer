import Vue from 'vue';
import App from './App';
import router from './router';
import store from './store';
import Loading from './components/lib/loading'
import CenterContainer from './components/lib/center-container'
import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue);

Vue.component('loading', Loading);
Vue.component('center-container', CenterContainer);

new Vue({
    router,
    store,
    render: h => h(App)
}).$mount('#app')
