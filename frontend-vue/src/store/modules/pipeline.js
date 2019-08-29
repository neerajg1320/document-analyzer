import apiAuth from "../../api/apiAuth";
import delayUtil from "../../utils/delayPromise";
import apiResource from "../../api/apiResource";

const state = {
  pipeline_id: "",
  operations: [],

  input_file_path: "",
  input_file_id: "",

  input_text: "",

  raw_table_schema: [],
  raw_table_data: [],

  mapped_table_schema: [],
  mapped_table_data: [],
}


const getters = {
  getOperations: state => state.operations,

  getInputText: state => state.input_text,

  getRawTable: state => state.raw_table_data,
  getRawTableSchema: state => state.raw_table_schema,

  getMappedTable: state => state.mapped_table_data,
  getMappedTableSchema: state => state.mapped_table_schema,
}


const actions = {

  addOperationToPipeline ({rootState, commit}, operation) {
    return new Promise((resolve, reject) => {
      if (operation.id) {
        commit('addOperationMut', operation)

      } else {
        const {token} = rootState.auth;
        apiResource.post('operations', token, operation)
          .then(resp => {
            commit('addOperationMut', resp);
            console.log(rootState.pipeline.operations);
          })
      }

    });
  },

  savePipeline ({rootState, commit, dispatch}) {
    return new Promise((resolve, reject) => {
      const {token} = rootState.auth;
      const pipeline = {
        "title": "EVP-101",
        "institute_name": "Etrade",
        "document_type": "ContractNote",
        "operations": rootState.pipeline.operations,
      };

      apiResource.post('pipelines', token, pipeline)
        .then(resp => {
          commit('setPipelineId', resp.id);
          console.log(resp);
          resolve(resp);
        });
    });
  },


}


const mutations = {
  setPipelineId(state, id) {
    state.pipeline_id = id;
  },

  setRawTable (state, table_data) {
    state.raw_table_data = table_data;
  },
  setRawTableSchema (state, table_schema) {
    state.raw_table_schema = table_schema;
  },

  setMappedTable (state, table_data) {
    state.mapped_table_data = table_data;
  },
  setMappedTableSchema (state, table_schema) {
    state.mapped_table_schema = table_schema;
  },

  addOperationMut (state, operation) {
    state.operations.push(operation.id);
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

