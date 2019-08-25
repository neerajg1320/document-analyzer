import { USER_REQUEST, USER_ERROR, USER_SUCCESS } from '../actions/user'
import apiAuth from '../../utils/apiAuth'
import Vue from 'vue'
import { AUTH_LOGOUT } from '../actions/auth'

const state = { status: '', profile: {} }

const getters = {
  getProfile: state => state.profile,
  isProfileLoaded: state => !!state.profile.name,
}

const actions = {
  [USER_REQUEST]: ({rootState, commit, dispatch}) => {
    const { token } = rootState.auth;

    commit(USER_REQUEST)

    apiAuth.getUserProfile(token)
      .then(resp => {
        commit(USER_SUCCESS, resp)
      })
      .catch(err => {

        commit(USER_ERROR)
        // if resp is unauthorized, logout, to
        dispatch(AUTH_LOGOUT)
        // eslint-disable-next-line
        console.error(err)
      })
  },
}

const mutations = {
  [USER_REQUEST]: (state) => {
    state.status = 'loading'
  },
  [USER_SUCCESS]: (state, resp) => {
    state.status = 'success'
    Vue.set(state, 'profile', resp)
  },
  [USER_ERROR]: (state) => {
    state.status = 'error'
  },
  [AUTH_LOGOUT]: (state) => {
    state.profile = {}
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
}
