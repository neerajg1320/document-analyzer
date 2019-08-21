<template>
  <div>
    <h2>The count: {{count}}</h2>
    <p>
      <button @click="count += 1">Increment</button>
    </p>
  </div>
</template>

<script>
  export default {
    name: "Counter",
    data() {
      return {
        count: 0
      };
    }
  }
</script>

<style scoped>

</style>
