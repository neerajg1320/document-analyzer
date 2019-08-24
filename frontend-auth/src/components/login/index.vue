<template>
  <div>
    <form class="login" @submit.prevent="login">
      <h1>Sign in</h1>
      <label>User name</label>
      <input required v-model="email" type="email" placeholder="email"/>
      <label>Password</label>
      <input required v-model="password" type="password" placeholder="password"/>
      <hr/>
      <button type="submit">Login</button>
    </form>
  </div>
</template>

<style>
  .login {
    display: flex;
    flex-direction: column;
    width: 300px;
    padding: 10px;
  }
</style>

<script>
  import {AUTH_REQUEST} from '../../store/actions/auth'

  export default {
    name: 'login',
    data () {
      return {
        email: 'alice@abc.com',
        password: 'Alice123',
      }
    },
    methods: {
      login: function () {
        const { email, password } = this;
        this.$store.dispatch(AUTH_REQUEST, { email, password }).then(() => {
          this.$router.push('/')
        })
      }
    },
  }
</script>
