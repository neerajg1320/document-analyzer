import Vue from 'vue';
import VueRouter from 'vue-router';
import App from './App';
import store from './store'; // index.js automatically assumed by webpack
import AuthHandler from './components/AuthHandler';
import ImageList from './components/ImageList';
import UploadForm from './components/UploadForm';

Vue.use(VueRouter);


export const router = new VueRouter({
    mode: 'history',
    routes: [
        {   path: '/',
            component: ImageList
        },
        {   path: '/upload',
            component: UploadForm
        },
        {   path: '/oauth2/callback',
            component: AuthHandler
        }
    ]
});


new Vue({
    router, // shortcut for router: router
    store, // shortcut for store: store
    render: h => h(App)
}).$mount('#app');