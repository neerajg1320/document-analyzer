import Vue from 'vue';
import axios from 'axios';


window.axios = axios;

windows.Vue = Vue;


window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
