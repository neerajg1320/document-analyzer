import axios from 'axios'
import apiDocMiner from './apiDocMiner';

export default {

  getList (resource, token) {
    return apiDocMiner.execute('get', `/${resource}/`, token)
  },

  get (resource, token, id) {
    return apiDocMiner.execute('get', `/${resource}/${id}/`, token)
  },
  post (resource, token, data) {
    return apiDocMiner.execute('post', `/${resource}/`, token, data)
  },
  put (resource, token, id, data) {
    return apiDocMiner.execute('put', `/${resource}/${id}/`, token, data)
  },
  patch (resource, token, id, data) {
    return apiDocMiner.execute('patch', `/${resource}/${id}/`, token, data)
  },
  del (resource, token, id) {
    return apiDocMiner.execute('delete', `/${resource}/${id}/`, token)
  }
}
