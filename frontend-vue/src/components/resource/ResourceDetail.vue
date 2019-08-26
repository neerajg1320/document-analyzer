<template>
    <div>
        <!-- Form for new resource -->
        <b-card :title="(model.id ? 'Edit ' + resource_name + ' ID#' + model.id : 'New ' + resource_name )">
            <form @submit.prevent="addInstance">
                <b-form-group label="Title">
                    <b-form-input type="text" v-model="model.title"></b-form-input>
                </b-form-group>
                <b-form-group label="Body">
                    <b-form-textarea rows="4" v-model="model.body"></b-form-textarea>
                </b-form-group>
                <div style="text-align: center">
                    <b-btn type="submit" variant="success">Save</b-btn>
                    <b-btn type="button" @click.prevent="onCancel" style="margin-left: 10px">Cancel</b-btn>
                </div>
            </form>
        </b-card>
    </div>
</template>

<script>
  export default {
    name: "ResourceDetail",

    created() {
      console.log(this.$route.path);
    }
  }
</script>

<style scoped>

</style>
