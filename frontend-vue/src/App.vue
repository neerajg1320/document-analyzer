<template>
    <div>
        <navigation/>
        <center-container>
            <router-view/>
        </center-container>
    </div>
</template>

<script>
  import navigation from './components/navigation/NavigationBar'

  export default {
    name: "App",
    components: {
      navigation
    }
  }
</script>

<style>
    body {
        margin: 0;
        font-family: 'Roboto', sans-serif;
        color: #2e426b;
    }
    ul {
        margin: 0;
        padding: 0;
        list-style-type: none;
    }
</style>

