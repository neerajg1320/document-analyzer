<template>
    <div>
        <b-row>
            <b-col>
                <b-button variant="success">Add</b-button>
            </b-col>
            <b-col>

            </b-col>
        </b-row>
        <b-row>
            <b-col>
                <OperationList :instances="operations"></OperationList>
            </b-col>
            <b-col>
                <OperationEditor :instances="operations"></OperationEditor>
            </b-col>
        </b-row>
    </div>
</template>

<script>
  import OperationList from './OperationList';
  import OperationEditor from './OperationEditor';

  export default {
    name: "Pipeline",
    components: {
      OperationList,
      OperationEditor
    },
    data() {
      return {
        operations: [
          {id: 100, title: "First", body: "Regex"},
          {id: 101, title: "Second", body: "Mapper"},
        ]
      };
    }
  }
</script>

<style scoped>

</style>
