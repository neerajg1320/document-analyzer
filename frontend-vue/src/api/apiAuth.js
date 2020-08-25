import axios from 'axios'
import apiAxios from './apiBaseAxios'

const API_HOST='192.168.1.106'
const API_PORT=8000
const API_URL='http://' + API_HOST + ':' + API_PORT + '/'

const client = axios.create({
  baseURL: API_URL,
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
