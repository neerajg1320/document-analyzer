import axios from "axios";
import apiDocMiner from './apiAxios';


const baseRequest = {
  baseURL: 'http://localhost:8000/api/docminer/',
  json: true
};

const client = axios.create(baseRequest);

export default {

  getList (resource, token) {
    return apiDocMiner.execute({client, method:'get', url:`/${resource}/`, token})
  },

  get (resource, token, id) {
    return apiDocMiner.execute({client, method:'get', url:`/${resource}/${id}/`, token})
  },
  post (resource, token, data) {
    return apiDocMiner.execute({client, method:'post', url:`/${resource}/`, token, data})
  },
  put (resource, token, id, data) {
    return apiDocMiner.execute({client, method:'put', url:`/${resource}/${id}/`, token, data})
  },
  patch (resource, token, id, data) {
    return apiDocMiner.execute({client, method:'patch', url:`/${resource}/${id}/`, token, data})
  },
  del (resource, token, id) {
    return apiDocMiner.execute({client, method:'delete', url:`/${resource}/${id}/`, token})
  }
}
