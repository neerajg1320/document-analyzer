
<template>
  <div>
    <div class="headline">
      <!--<img src="../../assets/dog-profile.jpeg">-->
      <h1>Your Account Profile</h1>
    </div>
    <b-alert :show="loading" variant="info">Loading...</b-alert>
    <p v-if="profile.name">
      <strong>Name:</strong> {{profile.title}} {{profile.name}}
    </p>
  </div>
</template>

<style lang="scss" scoped>
  .headline{
    margin-top: 1em;
    display: flex;
    img {
      height: 80px;
      width: 80px;
      border-radius: 50%;
    }
  }
</style>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'profile',
    data () {
      return {
        loading: false
      }
    },
    computed: mapState({profile: state => state.user.profile}),
    methods: {

    },

    // Resource and Profile have a shared creation code
    async created() {

    }
  }
</script>
