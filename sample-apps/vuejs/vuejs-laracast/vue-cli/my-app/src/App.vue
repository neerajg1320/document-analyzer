<template>
  <div id="app">
    <message>Hello There</message>
    <message>Hello Again</message>
  </div>
</template>

<script>
import Message from './components/Message';

export default {
  name: 'app',

  components: {Message},

  data () {
    return {

    }
  }
}
</script>

<style>

</style>
