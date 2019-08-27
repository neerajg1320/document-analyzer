<template>
    <div>
        <h3>Extractor</h3>
        <b-form-group label="Title">
            <b-form-input type="text" v-model="instance.title"></b-form-input>
        </b-form-group>
        <b-form-group label="Body">
            <b-form-textarea rows="4" v-model="instance.body"></b-form-textarea>
        </b-form-group>
    </div>
</template>

<script>
  import ResourceDynamicForm from './ResourceDynamicForm';

  export default {
    name: "Extractor",
    extends: ResourceDynamicForm,


  }
</script>

<style scoped>

</style>
