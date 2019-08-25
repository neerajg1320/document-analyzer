import axios from 'axios'

const client = axios.create({
  baseURL: 'http://localhost:8000/api/docminer/',
  json: true
})

export default {
  async execute (method, resource, token, data) {
    // When you authenticate with OIDC, an access token is persisted locally
    // in the browser.
    // Inject the accessToken for each request
    // let accessToken = await Vue.prototype.$auth.getAccessToken()
    return client({
      method,
      url: resource,
      data,
      headers: {
        Authorization: `token ${token}`
      }
    }).then(req => {
      return req.data
    })
  },

  getList (resource, token) {
    return this.execute('get', `/${resource}`, token)
  },

  get (resource, token, id) {
    return this.execute('get', `/${resource}/${id}`, token)
  },
  post (resource, token, data) {
    return this.execute('post', `/${resource}/`, token, data)
  },

  update (resource, token, id, data) {
    return this.execute('put', `/${resource}/${id}`, token, data)
  },
  del (resource, token, id) {
    return this.execute('delete', `/${resource}/${id}`, token)
  }
}
