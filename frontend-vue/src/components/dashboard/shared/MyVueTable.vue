<template>
    <div ref="table"></div>
</template>

<script>
  // https://stackoverflow.com/questions/54118873/issue-displaying-table-in-vuejs-using-tabulator
  var Tabulator = require('tabulator-tables');

  export default {
    name: "MyVueTable",

    data: function () {
      return {
        tabulator: null, // variable to hold your table
        tableData: [
          {name: 'Billy Bob', age: 12},
          {name: 'Mary May', age: 1}
        ] // data for table to display
      }
    },

    watch: {
      // update table if data changes
      tableData: {
        handler: function (newData) {
          this.tabulator.replaceData(newData)
        },
        deep: true
      }
    },

    created: function () {
      console.log('VueTable', this.$refs)
    },

    mounted () {
      // instantiate Tabulator when element is mounted
      this.tabulator = new Tabulator(this.$refs.table, {
        data: this.tableData, // link data to table
        columns: [
          {title: 'Name', field: 'name', sorter: 'string', width: 200, editor: true},
          {title: 'Age', field: 'age', sorter: 'number', align: 'right', editor: true}
        ]
      })
    },

  }
</script>

<style scoped>

</style>
