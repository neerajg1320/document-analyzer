import Vue from 'vue'
import Router from 'vue-router'

import Profile from '../components/profile/Profile'
import Login from '../components/login/Login'
import Resource from '../components/resource/ResourceManager'
import store from '../store'

Vue.use(Router)

const ifNotAuthenticated = (to, from, next) => {
  if (!store.getters.isAuthenticated) {
    next()
    return
  }
  next('/')
}

const ifAuthenticated = (to, from, next) => {
  if (store.getters.isAuthenticated) {
    next()
    return
  }
  next('/login')
}

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Resource,
      beforeEnter: ifAuthenticated,
    },
    {
      path: '/profile',
      name: 'Profile',
      component: Profile,
      beforeEnter: ifAuthenticated,
    },
    {
      path: '/login',
      name: 'Login',
      component: Login,
      beforeEnter: ifNotAuthenticated,
    },
    {
      path: '/resource/*',
      name: 'ResourceManager',
      component: Resource,
      beforeEnter: ifAuthenticated,
    },
  ],
})
