import axios from 'axios'
import apiAxios from './apiAxios'

const client = axios.create({
  baseURL: 'http://localhost:8000/',
  json: true
})

export default {
  register(user) {
    return apiAxios.execute({client, method:'post', url:'/api/user/create/', data:user})
  },

  login (user) {
    return apiAxios.execute({client, method:'post', url:'/api/user/token/', data:user})
  },

  getUserProfile (token) {
    return apiAxios.execute({client, method:'get', url:'api/user/me/', token})
  },

  logout (token) {
    return apiAxios.execute({client, method:'get', url:'api/user/me/', token})
  }
}
