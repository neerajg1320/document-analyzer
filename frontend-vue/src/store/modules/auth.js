import apiAuth from '../../api/apiAuth'

const state = {
  token: localStorage.getItem('user-token') || '',
  status: '',
  hasLoadedOnce: false
}

const getters = {
  isAuthenticated: state => !!state.token,
  authStatus: state => state.status,
}

const actions = {
  authRequest ({commit, dispatch}, user) {
    return new Promise((resolve, reject) => {
      commit('authRequest')

      apiAuth.login(user)
      .then(resp => {
        localStorage.setItem('user-token', resp.token)
        commit('authSuccess', resp)
        dispatch('userRequest')
        resolve(resp)
      })
      .catch(err => {
        commit('authError', err)
        localStorage.removeItem('user-token')
        reject(err)
      })
    })
  },

  authLogout ({rootState, commit}) {
    return new Promise((resolve, reject) => {
        localStorage.removeItem('user-token')
        const {token} = rootState.auth;
        commit('authLogout')

        // apiMock({url: 'user/me/logout', data: {}, method: 'GET'})
        apiAuth.logout(token)
            .then(resp => {
              resolve(resp)
            })
            .catch(err => {
              reject(err)
            })
    });
  }
}

const mutations = {
  authRequest (state) {
    state.status = 'loading'
  },
  authSuccess (state, resp) {
    state.status = 'success'
    state.token = resp.token
    state.hasLoadedOnce = true
  },
  authError (state) {
    state.status = 'error'
    state.hasLoadedOnce = true
  },
  authLogout (state) {
    state.token = ''
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
}
