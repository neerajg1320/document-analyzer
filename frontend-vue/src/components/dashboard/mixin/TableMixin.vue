<script>
  export default {
    methods: {
      addRow(table_data, row) {
        table_data.push(row)
      },

      addEmptyRow(table_data) {
        this.addRow(table_data, {})
      },

      getTableJson(table_ref) {
        if (table_ref) {
          const tabulatorInstance = table_ref.getInstance();
          if (tabulatorInstance) {
            return tabulatorInstance.getData("json");
          }
        }
      },

      setTableJson(table_ref, table_json) {
        if (table_ref) {
          const tabulatorInstance = table_ref.getInstance();
          if (tabulatorInstance) {
            console.log(table_json);
            return tabulatorInstance.setData(table_json);
          }
        }
      },

      downloadTable(table_ref) {
        if (table_ref) {
          const tabulatorInstance = table_ref.getInstance();
          if (tabulatorInstance) {
            tabulatorInstance.download("json", "table.json");
          }
        }
      },

      uploadTable(table_ref) {
        if (table_ref) {
          const tabulatorInstance = table_ref.getInstance();
          if (tabulatorInstance) {
            tabulatorInstance.setDataFromLocalFile([".json", ".csv"]);
          }
        }
      },
    }
  }
</script>

<style>
  .smart-table {
    overflow: hidden; /* This keeps children inside parent div */
  }
</style>
