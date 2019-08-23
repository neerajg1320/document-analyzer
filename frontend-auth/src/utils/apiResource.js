import Vue from 'vue'
import axios from 'axios'

const client = axios.create({
  baseURL: 'http://localhost:8081/',
  json: true
})

export default {
  async execute (method, resource, data) {
    // When you authenticate with OIDC, an access token is persisted locally
    // in the browser.
    // Inject the accessToken for each request
    let accessToken = await Vue.prototype.$auth.getAccessToken()
    return client({
      method,
      url: resource,
      data,
      headers: {
        Authorization: `Bearer ${accessToken}`
      }
    }).then(req => {
      return req.data
    })
  },

  getList (resource) {
    return this.execute('get', `/${resource}`)
  },

  get (resource, id) {
    return this.execute('get', `/${resource}/${id}`)
  },
  post (resource, data) {
    return this.execute('post', `/${resource}`, data)
  },
  updatePost (resource, id, data) {
    return this.execute('put', `/${resource}/${id}`, data)
  },
  deletePost (resource, id) {
    return this.execute('delete', `/${resource}/${id}`)
  }
}
