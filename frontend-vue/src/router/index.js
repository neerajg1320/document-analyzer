import Vue from 'vue'
import Router from 'vue-router'

import Profile from '../components/profile/Profile'
import Login from '../components/login/Login'
import Dashboard from '../components/dashboard/resource/ResouceDashboard'

import Extractor from '../components/dashboard/pipeline/DataExtractorRegex'
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
    // Home
    {
      path: '/',
      name: 'Home',
      component: Dashboard,
      beforeEnter: ifAuthenticated,
    },

    // User
    {
      path: '/login',
      name: 'Login',
      component: Login,
      beforeEnter: ifNotAuthenticated,
    },
    {
      path: '/profile',
      name: 'Profile',
      component: Profile,
      beforeEnter: ifAuthenticated,
    },

    // ResourceDashboard
    {
      path: '/resource/*',
      name: 'Dashboard',
      component: Dashboard,
      beforeEnter: ifAuthenticated,
    },

    // PipelineStudio
    {
      path: '/pipeline/extractor',
      name: 'Extractor',
      component: Extractor,
      props: { mode: 'studio' },
      beforeEnter: ifAuthenticated,
    },
    {
      path: '/pipeline/transformer',
      name: 'Transformer',
      component: Transformer,
      props: { mode: 'studio' },
      beforeEnter: ifAuthenticated,
    },
    {
      path: '/pipeline/loader',
      name: 'Loader',
      component: Loader,
      props: { mode: 'studio' },
      beforeEnter: ifAuthenticated,
    },
  ],
})
