import axios from 'axios'

const client = axios.create({
  baseURL: 'http://localhost:8000/',
  json: true
})

export default {
  async execute (method, resource, data, token) {
    // When you authenticate with OIDC, an access token is persisted locally
    // in the browser.
    // Inject the accessToken for each request
    // let accessToken = await Vue.prototype.$auth.getAccessToken()
    const request = {
      method,
      url: resource,
      data
    };

    if (token != undefined) {
      request['headers'] = {
        Authorization: `token ${token}`
      };
    }

    return client(request)
      .then(req => {
        return req.data
      })
  },

  register(user) {
    return this.execute('post', '/api/user/create/', user)
  },

  login (user) {
    return this.execute('post', '/api/user/token/', user)
  },

  getUserProfile (token) {
    return this.execute('get', 'api/user/me/', {}, token)
  },

  logout (token) {
    return this.execute('get', 'api/user/me/', {}, token)
  }
}
