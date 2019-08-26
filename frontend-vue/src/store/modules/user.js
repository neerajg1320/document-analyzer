import apiAuth from '../../utils/apiAuth'
// eslint-disable-next-line
import delayUtil from '../../utils/delayPromise'

const state = {
  status: '',
  profile: {},
  forceDelay: 0
}

const getters = {
  getProfile: state => state.profile,
  isProfileLoaded: state => !!state.profile.name,
}

const actions = {
  userRequest ({rootState, commit, dispatch}) {
    return new Promise((resolve, reject) => {
      const {token} = rootState.auth;

      commit('userRequest')

      apiAuth.getUserProfile(token)
          .then(resp => {
            delayUtil.delayPromise(rootState.user.forceDelay)
                .then(() => {
                  commit('userSuccess', resp);
                  resolve(resp);
                })
          })
          .catch(err => {
            commit('userError')
            dispatch('authLogout') // This needs to be corrected or accepted
            reject(err);
          })
    });
  },
}

const mutations = {
  userRequest (state) {
    state.status = 'loading'
  },
  userSuccess (state, resp) {
    state.status = 'success'
    state.profile = resp
    // Vue.set(state, 'profile', resp)
  },
  userError (state) {
    state.status = 'error'
  },
  authLogout (state) {
    state.profile = {}
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
}
