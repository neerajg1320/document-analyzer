import axios from 'axios'

const debug = true;

const baseRequest = {
  baseURL: 'http://localhost:8000/api/docminer/',
  json: true
};

const client = axios.create(baseRequest);


export default {
  async execute (method, resource, token, data) {
    // When you authenticate with OIDC, an access token is persisted locally
    // in the browser.
    // Inject the accessToken for each request
    // let accessToken = await Vue.prototype.$auth.getAccessToken()
    const request = {
      method,
      url: resource,
      data,
      headers: {
        Authorization: `token ${token}`
      }
    };

    if (debug) {
      console.log("request:", request);
    }

    return client(request)
        .then(response => {
          if (debug) {
            console.log("response", response);
          }
          return response.data
        })
  },

  getList (resource, token) {
    return this.execute('get', `/${resource}/`, token)
  },

  get (resource, token, id) {
    return this.execute('get', `/${resource}/${id}/`, token)
  },
  post (resource, token, data) {
    return this.execute('post', `/${resource}/`, token, data)
  },
  put (resource, token, id, data) {
    return this.execute('put', `/${resource}/${id}/`, token, data)
  },
  patch (resource, token, id, data) {
    return this.execute('patch', `/${resource}/${id}/`, token, data)
  },
  del (resource, token, id) {
    return this.execute('delete', `/${resource}/${id}/`, token)
  }
}
