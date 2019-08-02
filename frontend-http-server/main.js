// Document table which shows transactions present in a document
let g_document_table = new Tabulator("#document-transactions-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)
    autoColumns:true,

    rowClick: function(e, row){ //trigger an alert message when the row is clicked
        alert('Row index ' + row.getPosition() + ' clicked');
    },
});


let g_destination_header_table = new Tabulator("#destination-header-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)

    columns:[
        {title:"Name", field:"name", editor:"input", editable:true},
        {title:"Type", field:"type", editor:"select", editorParams: function(cell) {
                let hardcoded_values = {
                    "int64":"int64",
                    "float64":"float64",
                    "date":"date",
                    "object":"object",
                };

                return {"values": hardcoded_values};
            }
        },
        {title:"Aggregation", field:"aggregation", editor:"select", editorParams: function(cell) {
                let hardcoded_values = {
                    "none":"none",
                    "sum":"sum",
                    "mean":"mean",
                    "min":"min",
                    "max":"max",
                };

                return {"values": hardcoded_values};
            }
        },
    ],
});

let g_table_data_bank_statement = [
    {"name": "TransactionDate", "type": "object", "aggregation": "none"},
    {"name": "Description", "type": "object", "aggregation": "sum"},
    {"name": "Type", "type": "object", "aggregation": "none"},
    {"name": "Amount", "type": "float64", "aggregation": "sum"},
];

let g_table_data_contract_note = [
    {"name": "TransactionDate", "type": "object", "aggregation": "none"},
    {"name": "SettlementDate", "type": "object", "aggregation": "none"},
    {"name": "Scrip", "type": "object", "aggregation": "sum"},
    {"name": "Quantity", "type": "int64", "aggregation": "sum"},
    {"name": "TradeType", "type": "object", "aggregation": "none"},
    {"name": "Rate", "type": "float64", "aggregation": "none"},
    {"name": "PrincipalAmount", "type": "float64", "aggregation": "sum"},
    {"name": "Commission", "type": "float64", "aggregation": "sum"},
    {"name": "Fees", "type": "float64", "aggregation": "sum"},
    {"name": "NetAmount", "type": "float64", "aggregation": "sum"},
    {"name": "Summary", "type": "object", "aggregation": "sum"},
];

let g_table_data_receipt = [
    {"name": "Date", "type": "object", "aggregation": "none"},
    {"name": "Description", "type": "object", "aggregation": "sum"},
    {"name": "Quantity", "type": "int64", "aggregation": "sum"},
    {"name": "Rate", "type": "float64", "aggregation": "none"},
    {"name": "Amount", "type": "float64", "aggregation": "sum"},
];


// let g_table_data_dict = {
//     "bank_statement": g_table_data_bank_statement,
//     "contract_note": g_table_data_contract_note,
//     "receipt": g_table_data_receipt
// };


let g_table_dynamic_data_dict = {};

let g_table_datastore_parameters_description_dict = {};

let g_table_datastore_parameters_values_array = []


// Document table which shows transactions present in a document
let g_document_mapper_table = new Tabulator("#document-mapper-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)

    columns:[
        {title:"SourceColumn", field:"src"},
        {title:"Select", field:"select", editor:"tick", formatter:"tick", editable:true},

        {title:"DestinationColumn", field:"dst", editor:"select", editorParams: function(cell) {
                console.log(g_table_dynamic_data_dict);
                let destination_table = $("#sel-destination-header-table").val();
                console.log(destination_table);
                let dynamic_fields_array = g_table_dynamic_data_dict[destination_table];
                console.log(dynamic_fields_array);

                let fields_array = JSON.parse(g_table_dynamic_data_dict[destination_table]);
                let destination_fields = fields_array.map(a => a.name);

                const values = {};
                destination_fields.forEach(function(field_name) {
                        values[field_name] = field_name;
                    }
                );

                return {"values": values};
            }
        },

        // NG 2019-07-24 9:54am
        // Kept for one day in case we need to revert
        //
        // {title:"DestinationType", field:"dsttype", editor:"select", editorParams: function(cell) {
        //         let hardcoded_values = {
        //             "int64":"int64",
        //             "float64":"float64",
        //             "date":"date",
        //             "object":"object",
        //         };
        //
        //         return {"values": hardcoded_values};
        //     }
        // },
    ],
});



let g_document_mapped_table = new Tabulator("#document-mapped-transactions-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)
    autoColumns:true,

    rowClick: function(e, row){ //trigger an alert message when the row is clicked
        alert('Row index ' + row.getPosition() + ' clicked');
    },
});

// Regex transactions table which shows transactions extracted by the generated regex
// let g_regex_transactions_table = new Tabulator("#regex-transactions-table", {
//     height:300,
//     layout:"fitColumns", //fit columns to width of table (optional)
//     autoColumns:true,
//
//     rowClick: function(e, row){ //trigger an alert message when the row is clicked
//         alert('Row index ' + row.getPosition() + ' clicked');
//     },
// });
//

// Credentials to be used for loading data into account
let g_account_parameters_value_table = new Tabulator("#account-parameters-value-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)

    columns:[
        {title:"Parameter", field:"parameter"},
        {title:"Value", field:"value", editor:"input", editable:true},
    ],
});

// Credentials to be used for loading data into account
let g_account_parameters_description_table = new Tabulator("#account-parameters-description-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)

    columns:[
        {title:"Name", field:"name", editor:"input", editable:true},
        {title:"Mandatory", field:"mandatory", editor:"tick", formatter:"tick", editable:true},
        {title:"Type", field:"type", editor:"select", editorParams: function(cell) {
                let hardcoded_values = {
                    "int64":"int64",
                    "float64":"float64",
                    "date":"date",
                    "object":"object",
                };

                return {"values": hardcoded_values};
            }
        },
    ],
});

// Account table which shows transactions in all the documents uploaded for an account
let g_account_table = new Tabulator("#account-transactions-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)
    autoColumns:true,

    rowClick: function(e, row){ //trigger an alert message when the row is clicked
        alert('Row index ' + row.getPosition() + ' clicked');
    },
});

let g_config_automate_flow = true;

let g_document_text_box = $("#document-text");
let g_regex_text_box = $("#regex-text");

let g_document_dataframe_box = $("#document-dataframe");
let g_document_mapped_dataframe_box = $("#document-mapped-dataframe");


var g_current_document = null;
var g_current_document_local_cache = {};


var g_file_info = {};

$("#fileinfo").submit(function(e) {
    e.preventDefault();

    var formData = new FormData($(this)[0]);

    $.ajax({
        url: $(this).attr('action'),
        type: $(this).attr('method'),
        data: formData,
        headers: {'Authorization': 'Token ' + g_user_auth_token},
        cache: false,
        contentType: false,
        processData: false,
        success: function(response) {
            g_file_info = response;
            console.log(g_file_info);

            // alert('File upload successful (id = ' + response.id + ')');
            $("#input_file_id").val(response.id);
            if (g_config_automate_flow) {
                $("#btn_documentize").click();
            }
        },
    });
});


// These functions should have no knowledge of elements extractions
//
function set_sample_transactions(tabulator_table) {
    tabulator_table.setData(credit_card_data);
}

function download_document_transactions(user_auth_token, document_id, tabulator_table, elm_text_box, elm_dataframe_box) {
    if (document_id == "") {
        alert("Please provide a valid document Id");
        return;
    }

    // http://localhost:8000/api/docminer/documents/<document_id>/
    let document_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/';
    g_current_document_local_cache['document_url'] = document_url;

    $.ajax({
        url: document_url,
        headers : {
            'Authorization' : 'Token ' + user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            g_current_document = response;

            document.getElementById("document-text-url").innerHTML = document_url;
            elm_text_box.empty().append(response.text);
        }
    });

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_transactions_json_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/json/';

    $.ajax({
        url: document_transactions_json_url,
        headers : {
            'Authorization' : 'Token ' + user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            // console.log(typeof(response), response);
            //response is already a parsed JSON
            document.getElementById("document-transactions-json-url").innerHTML = document_transactions_json_url;
            tabulator_table.setData(response);

        }
    });

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/dataframe/
    let document_transactions_dataframe_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/dataframe/';

    $.ajax({
        url: document_transactions_dataframe_url,
        headers : {
            'Authorization' : 'Token ' + user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            // console.log(typeof(response), response);
            //response is already a parsed JSON
            document.getElementById("document-transactions-dataframe-url").innerHTML = document_transactions_dataframe_url;
            elm_dataframe_box.empty().append(response);
        }
    });
}


// These function deal with the elements
//
function download_document_using_input(tabulator_table, user_auth_token) {
    let document_id = $("#input_document_id").val();

    download_document_transactions(user_auth_token,
        document_id, tabulator_table, g_document_text_box, g_document_dataframe_box);
}

function documentize_file(user_auth_token, file_id, result_elm) {
    // http://localhost:8000/api/docminer/files/<document_id>/documentize/
    let file_documentize_url = 'http://localhost:8000/api/docminer/files/' + file_id + '/documentize/';

    $.ajax({
        url: file_documentize_url,
        headers : {
            'Authorization' : 'Token ' + user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            result_elm.val(response.id);
            if (g_config_automate_flow) {
                $("#btn_get_text").click();
            }
        }
    });
}

// Ref: https://stackoverflow.com/questions/5379120/get-the-highlighted-selected-text
function getSelectionText() {
    var text = "";
    if (window.getSelection) {
        text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
        text = document.selection.createRange().text;
    }
    return text;
}

$("#btn_load_file").click(function() {
    g_document_table.setDataFromLocalFile(".json");
});

function replaceAll(str, find, replace) {
    return str.replace(new RegExp(find, 'g'), replace);
}

String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.split(search).join(replacement);
};


$("#btn_create_regex").click(function() {
    var selected_text = getSelectionText()
    console.log(selected_text);

    // Get document id
    let document_id = $("#input_document_id").val();

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_row_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/regex/create/';
    document.getElementById("document-create_regex-url").innerHTML = document_row_url;

    var complete_text = g_document_text_box.val();

    // console.log("Complete Text:\n" + complete_text);

    $.ajax({
        type: 'POST',
        url: document_row_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        data: {
            "selected_text": selected_text,
            "complete_text": complete_text
        },
        success: function(response) {
            console.log(typeof(response), response);
            //response is already a parsed JSON

            // alert("Transactions saved");
            // g_account_table.setData(response);
            var new_str = response[0]['new_str'];
            document.getElementById("document-text-url").innerHTML = document_row_url;
            g_document_text_box.empty().append(new_str);

            var regex_str = response[0]['regex'];
            // console.log(regex_str)
            // display_regex_str = regex_str.replaceAll("<", "{").replaceAll(">", "}");
            // g_regex_text_box.value = display_regex_str;
            document.getElementById('regex-text').value = regex_str;
            g_current_document_local_cache['regex_str'] = regex_str;
        }
    });

});

$("#btn_reset_text").click(function() {
    document.getElementById("document-text-url").innerHTML = g_current_document_local_cache['document_url'];
    g_document_text_box.empty().append(g_current_document.text);
});


$("#btn_apply_regex").click(function() {
    // Get document id
    let document_id = $("#input_document_id").val();

    let document_apply_regex_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/regex/apply/';

    console.log(document_apply_regex_url);

    var regex_text = g_regex_text_box.val();
    // var complete_text = g_document_text_box.val();
    var complete_text = g_current_document.text;

    // console.log("Complete Text:\n" + complete_text);

    $.ajax({
        type: 'POST',
        url: document_apply_regex_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        data: {
            "regex_text": regex_text,
            "complete_text": complete_text
        },
        success: function(response) {
            console.log(typeof(response), response);
            //response is already a parsed JSON

            // alert("Transactions saved");
            // g_account_table.setData(response);
            var new_str = response[0]['new_str'];
            g_document_text_box.empty().append(new_str);

            var dataframe = response[0]['dataframe'];
            g_document_dataframe_box.empty().append(dataframe);

            var transactions = response[0]['transactions'];
            g_document_table.setData(transactions);
        }
    });

});

let g_operation_pipeline_array = [];

function save_operation(title, type, parameters) {
    let operation_save_url = 'http://localhost:8000/api/docminer/operations/';

    console.log(operation_save_url);

    // console.log("Complete Text:\n" + complete_text);

    $.ajax({
        type: 'POST',
        url: operation_save_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        data: {
            "title": title,
            "type": type,
            "parameters": parameters
        },
        success: function(response) {
            console.log(typeof(response), response);
            //response is already a parsed JSON

            // alert("Regex saved");
            // g_operation_pipeline_array.push(response.id);
            g_operation_pipeline_array.push(response.id);

            console.log("Pipeline_array:", g_operation_pipeline_array);
        }
    });
}


$("#btn_save_regex").click(function() {
    // Get document id
    let regex_name = $("#input_regex_name").val();
    if (regex_name == "") {
        alert('Please provide regex name!');
        return;
    }

    var regex_text = g_regex_text_box.val();
    if (regex_text == "") {
        alert('Please provide regular expression!');
        return;
    }

    save_operation(regex_name, "Extract", regex_text);
});


$("#btn_reset_regex").click(function() {
    document.getElementById('regex-text').value = g_current_document_local_cache['regex_str'];
});


$("#btn_get_text").click(function() {
    download_document_using_input(g_document_table, g_user_auth_token);
});

$("#btn_download_excel").click(function () {
    g_document_table.download("csv", "trades.csv");
});

$("#btn_download_mapped_table_excel").click(function () {
    g_document_mapped_table.download("csv", "mapped_trades.csv");
});

$("#btn_upload_mapper").click(function () {
    g_document_mapper_table.setDataFromLocalFile();
});

$("#btn_download_mapper").click(function () {
    g_document_mapper_table.download("json", "mapper.json");
});


$("#btn_documentize").click(function() {
    var file_id = $("#input_file_id").val();
    input_document_elm = $("#input_document_id");
    documentize_file(g_user_auth_token, file_id, input_document_elm);
});


$("#sel-destination-header-table").on('change', function() {
    console.log(this.value);

    if (this.value == "new") {
        document.getElementById('input_new_schema').style.display = "";
        g_destination_header_table.setData('[]')
    } else {
        document.getElementById('input_new_schema').style.display = "none";
        // g_destination_header_table.setData(g_table_data_dict[this.value]);
        g_destination_header_table.setData(g_table_dynamic_data_dict[this.value]);

    }
});


$("#btn_get_mapper").click(function () {
    // Get document id
    let document_id = $("#input_document_id").val();

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_transactions_get_mapper_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/mapper/';

    console.log(document_transactions_get_mapper_url);

    $.ajax({
        url: document_transactions_get_mapper_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);
            //response is already a parsed JSON

            // alert("Transactions saved");
            g_document_mapper_table.setData(response);
        }
    });

});


$("#btn_apply_mapper").click(function () {
    // Get document id
    let document_id = $("#input_document_id").val();

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_transactions_get_mapper_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/mapper/';

    let destination_table = $("#sel-destination-header-table").val();

    console.log(document_transactions_get_mapper_url);
    var table_data_json_str = JSON.stringify(g_document_mapper_table.getData("json"));
    console.log(typeof(table_data_json_str), table_data_json_str);

    $.ajax({
        type: 'POST',
        data: {
            "destination_table": destination_table,
            "mapper": table_data_json_str
        },
        url: document_transactions_get_mapper_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);
            //response is already a parsed JSON

            var mapped_dataframe = response[0]['mapped_df'];
            console.log(typeof(mapped_dataframe), mapped_dataframe);
            g_document_mapped_dataframe_box.empty().append(mapped_dataframe);

            var mapped_transactions = response[0]['mapped_df_json'];
            g_document_mapped_table.setData(mapped_transactions);
        }
    });

});

$("#btn_save_mapper").click(function() {
    // Get document id
    let mapper_name = $("#input_mapper_name").val();
    if (mapper_name == "") {
        alert('Please provide mapper name!');
        return;
    }

    var mapper_json = JSON.stringify(g_document_mapper_table.getData("json"));
    if (mapper_json == "") {
        alert('Please provide regular expression!');
        return;
    }

    save_operation(mapper_name, "Transform", mapper_json);
});

$("#btn_get_schema_list").click(function () {

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let schema_get_url = 'http://localhost:8000/api/docminer/schemas/';

    console.log(schema_get_url);

    $.ajax({
        url: schema_get_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);


            // Find the title elements of the json array received
            // e.g. schemas = ["receipt", "contract_nt", "bank_stmt"]
            let schemas = response.map(a => a.title);

            console.log(schemas);

            let destination_select = $("#sel-destination-header-table");
            destination_select.empty();

            let new_entry_str = "new";
            destination_select.append($('<option></option>').attr('value', new_entry_str).text(new_entry_str));

            $.each(response, function (key, entry) {
                destination_select.append($('<option></option>').attr('value', entry.title).text(entry.title));
                // Create the global dictionary
                g_table_dynamic_data_dict[entry.title] = entry.fields_json;
            });

            document.getElementById('input_new_schema').style.display = "";

            // console.log(g_table_dynamic_data_dict);
        }
    });
});


$("#btn_get_datastore_list").click(function () {

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let datastore_get_url = 'http://localhost:8000/api/docminer/datastores/';

    console.log(datastore_get_url);

    $.ajax({
        url: datastore_get_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);


            // Find the title elements of the json array received
            // e.g. schemas = ["receipt", "contract_nt", "bank_stmt"]
            let schemas = response.map(a => a.title);

            console.log(schemas);

            let destination_select = $("#sel-datastore");
            destination_select.empty();

            let new_entry_str = "new";
            destination_select.append($('<option></option>').attr('value', new_entry_str).text(new_entry_str));

            $.each(response, function (key, entry) {
                destination_select.append($('<option></option>').attr('value', entry.title).text(entry.title));
                // Create the global dictionary

                g_table_datastore_parameters_description_dict[entry.title] = entry.parameters;

                console.log(typeof (entry.parameters), entry.parameters);
                // g_table_datastore_parameters_values_array
            });

            document.getElementById('input_new_schema').style.display = "";


            // console.log(g_table_dynamic_data_dict);
        }
    });
});

// Keep this for later
$("#btn_save_datastore").click(function() {
    // Get document id
    let datastore_name = $("#input_new_datastore").val();
    if (datastore_name == "") {
        alert('Please provide datastore name!');
        return;
    }

    var datastore_values_json_str = JSON.stringify(g_account_parameters_value_table.getData("json"));
    if (datastore_values_json_str == "") {
        alert('Please provide datastore values expression!');
        return;
    }

    // save_operation("S1", "Load", "{}");
    save_operation(datastore_name, "Load", datastore_values_json_str);
});


$("#sel-datastore").on('change', function() {
    console.log(this.value);

    if (this.value == "new") {
        // document.getElementById('input_new_datastore').style.display = "";
        g_account_parameters_description_table.setData('[]')
    } else {
        // document.getElementById('input_new_datastore').style.display = "none";

        let parameters_array_json = g_table_datastore_parameters_description_dict[this.value];
        console.log(parameters_array_json);

        let parameters = JSON.parse(parameters_array_json);
        let parameter_names = parameters.map(a => a.name);
        console.log(parameter_names);

        // In the value we can provide the default value
        g_table_datastore_parameters_values_array = parameters.map(function(parameter) {
           return {"parameter": parameter.name, "value": ""};
        });

        g_account_parameters_description_table.setData(g_table_datastore_parameters_description_dict[this.value]);
        g_account_parameters_value_table.setData(g_table_datastore_parameters_values_array);
    }
});

$("#btn_upload_datastore").click(function () {
    g_account_parameters_value_table.setDataFromLocalFile();
});

$("#btn_download_datastore").click(function () {
    g_account_parameters_value_table.download("json", "datastore.json");
});


$("#btn_load_to_datastore").click(function () {
    // Get document id
    let document_id = $("#input_document_id").val();

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_transactions_save_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/save/';

    console.log(document_transactions_save_url);

    let store_type = $("#sel-datastore").val();
    if (store_type == "new") {
        alert('Please provide datastore type!');
        return;
    }

    let store_parameters_table_values = g_account_parameters_value_table.getData("json");

    let final_store_parameters_values = {}
    store_parameters_table_values.forEach(function(entry) {
        final_store_parameters_values[entry.parameter] = entry.value;
    });
    console.log(final_store_parameters_values);

    let dataframe_json_str = JSON.stringify(g_document_mapped_table.getData("json"));
    console.log(typeof(dataframe_json_str), dataframe_json_str);

    // let store_parameters_values = JSON.stringify(g_account_parameters_value_table.getData("json"));
    // if (store_type == "new") {
    //     alert('Please provide datastore type!');
    //     return;
    // }

    $.ajax({
        type: 'POST',
        url: document_transactions_save_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        data: {
            "store_type": store_type,
            "parameter_values": JSON.stringify(final_store_parameters_values),
            "dataframe_json":dataframe_json_str
        },
        success: function(response) {
            // console.log(typeof(response), response);
            //response is already a parsed JSON

            // alert("Transactions saved");
            g_account_table.setData(response);
        }
    });

});

$("#btn_save_pipeline").click(function () {
    // Get document id
    let pipeline_name = $("#input_new_pipeline").val();

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let pipeline_save_url = 'http://localhost:8000/api/docminer/pipelines/';
    console.log(pipeline_save_url);

    // g_operation_pipeline_array = [19,20,21];

    if (g_operation_pipeline_array.length < 1) {
        alert("Please save ETL operations before saving pipeline");
        return;
    }

    let json_data = JSON.stringify({
        "title": pipeline_name,
        "institute_name": g_file_info.institute_name,
        "document_type": g_file_info.document_type,
        "operations": g_operation_pipeline_array
    });

    $.ajax({
        type: 'POST',
        url: pipeline_save_url,
        data: json_data,
        dataType: 'json',
        contentType: "application/json",
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },

        success: function(response) {
            console.log(typeof(response), response);
            //response is already a parsed JSON

        }
    });

});


$(document).ready(function() {
    download_document_using_input(g_document_table, g_user_auth_token);
});


