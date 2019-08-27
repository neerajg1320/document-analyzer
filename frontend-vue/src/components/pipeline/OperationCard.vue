<template>
    <div>
        <div>
            <b-card
                    :title="resource"
                    img-src="https://picsum.photos/600/100/?image=25"
                    img-alt="Image"
                    img-top
                    tag="article"
                    style="max-width: 20rem;"
                    class="mb-2"
            >
                <b-card-text>
                    {{ instance.body }}
                </b-card-text>

                <b-button href="#" variant="primary">Edit</b-button>
            </b-card>
        </div>
    </div>
</template>

<script>
  export default {
    name: "OperationCard",
    props: ['instance'],

    data() {
      return {
        resource: "Operation",
        initInstance: {
          id: 0,
          title: "None",
          body: "To be filled"
        }
      }
    }
  }
</script>

<style scoped>

</style>
