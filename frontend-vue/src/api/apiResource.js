import axios from "axios";
import apiAxios from './apiAxios';


const baseRequest = {
  baseURL: 'http://localhost:8000/api/docminer/',
  json: true
};

const client = axios.create(baseRequest);

export default {

  getList (resource, token) {
    return apiAxios.execute({client, method:'get', url:`/${resource}/`, token})
  },

  get (resource, token, id) {
    return apiAxios.execute({client, method:'get', url:`/${resource}/${id}/`, token})
  },
  post (resource, token, data) {
    return apiAxios.execute({client, method:'post', url:`/${resource}/`, token, data})
  },
  put (resource, token, id, data) {
    return apiAxios.execute({client, method:'put', url:`/${resource}/${id}/`, token, data})
  },
  patch (resource, token, id, data) {
    return apiAxios.execute({client, method:'patch', url:`/${resource}/${id}/`, token, data})
  },
  del (resource, token, id) {
    return apiAxios.execute({client, method:'delete', url:`/${resource}/${id}/`, token})
  },
  action (resource, action, token, data) {
    return apiAxios.execute({client, method:'post', url:`/${resource}/${action}/`, token, data})
  },
}
