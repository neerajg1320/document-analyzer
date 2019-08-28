import apiDocMiner from './apiDocMiner';

export default {

  getList (resource, token) {
    return apiDocMiner.execute({method:'get', url:`/${resource}/`, token})
  },

  get (resource, token, id) {
    return apiDocMiner.execute({method:'get', url:`/${resource}/${id}/`, token})
  },
  post (resource, token, data) {
    return apiDocMiner.execute({method:'post', url:`/${resource}/`, token, data})
  },
  put (resource, token, id, data) {
    return apiDocMiner.execute({method:'put', url:`/${resource}/${id}/`, token, data})
  },
  patch (resource, token, id, data) {
    return apiDocMiner.execute({method:'patch', url:`/${resource}/${id}/`, token, data})
  },
  del (resource, token, id) {
    return apiDocMiner.execute({method:'delete', url:`/${resource}/${id}/`, token})
  }
}
