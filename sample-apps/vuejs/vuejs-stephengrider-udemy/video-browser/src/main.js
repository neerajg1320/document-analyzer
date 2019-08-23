import Vue from 'vue';
import App from './App';

new Vue({
    // render: function(createElement) {
    //     return createElement(App);
    // }

    // render: function(h) {
   //     return h(App);
   // }

    // el: '#app',
    render: h => h(App)
}).$mount('#app');