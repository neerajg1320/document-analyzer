import Vue from 'vue'
import Router from 'vue-router'

import Profile from '../components/profile/Profile'
import Login from '../components/login/Login'
import Dashboard from '../components/dashboard/resource/ResouceDashboard'

import PipelineStudio from '../components/dashboard/pipeline/PipelineStudio'
import Extractor from '../components/dashboard/pipeline/DataExtractor'
import Transformer from '../components/dashboard/pipeline/DataTransformer'
import Loader from '../components/dashboard/pipeline/DataLoader'

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
      component: Dashboard,
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
      name: 'Dashboard',
      component: Dashboard,
      beforeEnter: ifAuthenticated,
    },
    {
      path: '/pipeline/studio',
      name: 'PipelineStudio',
      component: PipelineStudio,
      beforeEnter: ifAuthenticated,
    },
    {
      path: '/pipeline/extractor',
      name: 'Extractor',
      component: Extractor,
      beforeEnter: ifAuthenticated,
    },
    {
      path: '/pipeline/transformer',
      name: 'Transformer',
      component: Transformer,
      beforeEnter: ifAuthenticated,
    },
    {
      path: '/pipeline/loader',
      name: 'Extractor',
      component: Loader,
      beforeEnter: ifAuthenticated,
    },
  ],
})
