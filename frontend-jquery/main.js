// Document table which shows transactions present in a document
let g_document_table = new Tabulator("#document-transactions-table", {
    height:300,
    layout:"fitData", //fit columns to width of table (optional)
    layoutColumnsOnNewData:true,
    autoColumns:true,

    rowClick: function(e, row){ //trigger an alert message when the row is clicked
        alert('Row index ' + row.getPosition() + ' clicked');
    },
});


let g_schema_table = new Tabulator("#destination-header-table", {
    height:300,
    layout:"fitData", //fit columns to width of table (optional)
    layoutColumnsOnNewData:true,
    movableRows: true,

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
        // https://github.com/olifolkerd/tabulator/issues/942
        {title:"Delete", formatter:"buttonCross", width:40, align:"center", cellClick:function(e, cell){
                cell.getRow().delete();
            }
        },
    ],
});

$("#btn_add_schema_field").click(function() {
    g_schema_table.addRow({});
});


let g_table_schema_dict = {};

let g_table_datastoretype_parameters_description_dict = {};

let g_table_datastore_parameters_values_array = []


let temp_mapper_type_edit_check = function(cell){
    //get row data
    let row = cell.getRow().getData();

    return row.mapping == "SPLIT_SEP" || row.mapping == "SPLIT_REGEX_STATIC"; // only allow the name cell to be edited if the age is over 18
}


// Document table which shows transactions present in a document
let g_document_mapper_table = new Tabulator("#document-mapper-table", {
    height:300,
    layout:"fitData", //fit columns to width of table (optional)
    layoutColumnsOnNewData:true,

    columns:[
        {title:"SourceColumn", field:"src"},
        {title:"SourceColumnType", field:"srctype"},

        {title:"Mapping", field:"mapping", editor:"select", editorParams: function(cell) {
                let values = {
                    "IGNORE": "IGNORE",
                    "RENAME": "RENAME",
                    "SPLIT_SEP": "SPLIT_SEP",
                    "SPLIT_REGEX_STATIC": "SPLIT_REGEX_STATIC",
                    "SPLIT_REGEX_DYNAMIC": "SPLIT_REGEX_DYNAMIC",
                };

                return {"values": values};
            }
        },
        {title:"DestinationColumn", field:"dst", editor:"select", editorParams: function(cell) {
                let row = cell.getRow().getData();
                console.log(row.mapping);

                const values = {"None": "None"};
                if (row.mapping != "IGNORE") {

                    console.log(g_table_schema_dict);
                    let destination_table = $("#sel-destination-schema").val();
                    console.log(destination_table);
                    let dynamic_fields_array = g_table_schema_dict[destination_table].fields_json;
                    console.log(dynamic_fields_array);

                    let fields_array = JSON.parse(dynamic_fields_array);
                    let destination_fields = fields_array.map(a => a.name);

                    destination_fields.forEach(function (field_name) {
                            values[field_name] = field_name;
                        }
                    );
                }

                return {"values": values};
            }
        },
        {title:"Parameters", field:"parameters", editor:"input", editable: temp_mapper_type_edit_check},
    ],
});


let temp_column_name_edit_check = function(cell){
    //get row data
    let row = cell.getRow().getData();

    return row.type == "Generate-Temp" || row.type == "Generate-Regex"; // only allow the name cell to be edited if the age is over 18
}


let g_document_mapper_newfields_table = new Tabulator("#document-mapper-newfields-table", {
    height:300,
    layout:"fitData",
    layoutColumnsOnNewData:true,
    movableRows: true,
    data: [
        {"type": "", "temp_name": "", "dst": "", "value":"None"}
    ],
    columns:[
        {title:"Active", field:"active", editor:"tick", formatter:"tick", editable:true},
        {title:"Rule-Type", field:"type", editor:"select", editable:true, editorParams: function(cell) {
                console.log(cell.getRow().getData());

                values = {};
                values["Generate-Temp"] = "Generate-Temp";
                values["Generate-Final"] = "Generate-Final";
                values["Generate-Regex"] = "Generate-Regex";

                return {"values": values};
            }
        },
        {title:"SrcColumn", field:"src", editor:"select", editorParams: function(cell) {
                let row = cell.getRow().getData();
                console.log(row);

                const values = {};
                if (row.type == "Generate-Regex") {
                    let src_fields_array = g_document_mapper_table.getData("json");

                    // Create a list of unassigned fields
                    console.log(src_fields_array);
                    src_fields_array.forEach(function (src_field) {
                            if (src_field.mapping == "SPLIT_REGEX_DYNAMIC") {
                                values[src_field.src] = src_field.src;
                            }
                        }
                    );
                }

                return {"values": values};
            }
        },
        {title:"TempColumn", field:"temp_name", editor:"input", editable: temp_column_name_edit_check},
        {title:"SchemaColumn", field:"dst", editor:"select", editorParams: function(cell) {
                let row = cell.getRow().getData();
                console.log(row);

                const values = {};
                if (row.type == "Generate-Final") {
                    let destination_table = $("#sel-destination-schema").val();

                    let fields_array = JSON.parse(g_table_schema_dict[destination_table].fields_json);
                    let destination_fields = fields_array.map(a => a.name);

                    // Find list of fields already assigned
                    let mapper_array = g_document_mapper_table.getData("json");
                    let assigned_field_set = new Set(mapper_array.map(a => a.dst));

                    // Create a list of unassigned fields

                    destination_fields.forEach(function (field_name) {
                            if (!assigned_field_set.has(field_name))
                                values[field_name] = field_name;
                        }
                    );
                }

                return {"values": values};
            }
        },
        {title:"Value", field:"value", editor:"input", editable:true},
        {title:"Delete", formatter:"buttonCross", width:40, align:"center", cellClick:function(e, cell){
                cell.getRow().delete();
            }
        },
    ],
});




let g_document_mapped_table = new Tabulator("#document-mapped-transactions-table", {
    height:300,
    layout:"fillData",
    layoutColumnsOnNewData:true,
    autoColumns:true,

    rowClick: function(e, row){ //trigger an alert message when the row is clicked
        alert('Row index ' + row.getPosition() + ' clicked');
    },
});

// Regex transactions table which shows transactions extracted by the generated regex
// let g_regex_transactions_table = new Tabulator("#regex-transactions-table", {
//     height:300,
//     layout:"fitData", //fit columns to width of table (optional)
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
    layout:"fitData", //fit columns to width of table (optional)

    columns:[
        {title:"Parameter", field:"parameter"},
        {title:"Value", field:"value", editor:"input", editable:true},
    ],
});

// Credentials to be used for loading data into account
let g_account_parameters_description_table = new Tabulator("#account-parameters-description-table", {
    height:300,
    layout:"fitData", //fit columns to width of table (optional)

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
    console.log(formData);

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

$("#input_file").on('change', function() {
    let file_path = this.value;
    let file_name = file_path.split("/").pop();
    let file_extn = file_name.split(".").pop();

    let select_extractor_type = document.getElementById('sel-extractor-type');
    if (file_extn == "csv" || file_extn == "xls" || file_extn == "xlsx") {
        select_extractor_type.value = "excel";
    } else {
        select_extractor_type.value = "regex";
    }

    let event = new Event('change');
    select_extractor_type.dispatchEvent(event);
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

$("#sel-extractor-type").on('change', function() {
    console.log(this.value);

    if (this.value == "regex") {
        document.getElementById('extractor-regex-box').style.display = "";
    } else {
        document.getElementById('extractor-regex-box').style.display = "none";
    }
});

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

            let new_str = response['new_str'];
            document.getElementById("document-text-url").innerHTML = document_row_url;
            g_document_text_box.empty().append(new_str);

            let regex_str = response['regex'];
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


            g_document_text_box.empty().append(response['new_str']);
            g_document_dataframe_box.empty().append(response['dataframe']);
            g_document_table.setData(response['transactions']);
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

function get_operation_dict_for_extractor() {
    // Get document id
    let extractor_name = $("#input_new_extractor").val();
    if (extractor_name == "") {
        alert('Please provide regex name!');
        return;
    }

    let extractor_type = $("#sel-extractor-type").val();
    let extractor_parameters = {
        "type": extractor_type
    };

    if (extractor_type == "regex") {
        var regex_text = g_regex_text_box.val();
        if (regex_text == "") {
            alert('Please provide regular expression!');
            return;
        }

        extractor_parameters["parameters"] = {
            "regex": regex_text
        };
    }

    let extractor_parameters_json = JSON.stringify(extractor_parameters);

    return  {
        "title": extractor_name,
        "type": "Extract",
        "parameters": extractor_parameters_json
    };
}

function handle_extractor_operation_response(response) {
    console.log(response);

    let new_str = response['new_str'];
    g_document_text_box.empty().append(new_str);

    let dataframe = response['dataframe'];
    g_document_dataframe_box.empty().append(dataframe);

    let transactions = response['transactions'];
    g_document_table.setData(transactions);

    g_table_schema = response['schema'];
}

function handle_operation_response(operation, response) {
    console.log(operation, response);

    if (operation.type == "Extract") {
        handle_extractor_operation_response(response);
    } else  if (operation.type == "Transform") {
        handle_mapper_operation_response(response);
    } else if (operation.type == "Load") {
        handle_loader_operation_response(response);
    }

    if (g_flag_pipeline_active) {
        console.log(g_operations_array);
        perform_pipeline_operation();
    }
}

$("#btn_apply_extractor").click(function () {
    let operation = get_operation_dict_for_extractor();
    let text = g_current_document.text;

    let dataframe_json = [{'text': text}]

    apply_operation(operation, dataframe_json, handle_operation_response);
});

$("#btn_save_extractor").click(function() {
    let operation = get_operation_dict_for_extractor();

    // We need to support this at the backend
    save_operation(operation.title, operation.type, operation.parameters);
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

$("#btn_upload_newfields_table").click(function () {
    g_document_mapper_newfields_table.setDataFromLocalFile();
});

$("#btn_download_newfields_table").click(function () {
    g_document_mapper_newfields_table.download("json", "mapper.json");
});

$("#btn_documentize").click(function() {
    var file_id = $("#input_file_id").val();
    input_document_elm = $("#input_document_id");
    documentize_file(g_user_auth_token, file_id, input_document_elm);
});


$("#sel-destination-schema").on('change', function() {
    let schema_id = this.value;
    console.log(schema_id);

    if (schema_id == "new") {
        $("#input_new_schema").val('');
        g_schema_table.setData('[]')
    } else {
        let schema = g_table_schema_dict[this.value];
        $("#input_new_schema").val(schema.title);
        // g_schema_table.setData(g_table_data_dict[this.value]);
        g_schema_table.setData(schema.fields_json);

    }
});


$("#btn_create_mapper").click(function () {
    console.log(g_table_schema);
    g_table_schema.forEach(row => row['mapping'] = "RENAME");
    g_document_mapper_table.setData(g_table_schema);
});


function get_operation_dict_for_mapper()
{
    // Get document id
    let mapper_name = $("#input_new_mapper").val();
    if (mapper_name == "") {
        alert('Please provide mapper name!');
        return;
    }

    let destination_table = $("#sel-destination-schema").val();
    if (destination_table == "") {
        alert('Please provide destination table!');
        return;
    }


    // Convert backslashes to double backslashes: preparing for python strings
    let table_new_fields = g_document_mapper_newfields_table.getData("json");
    table_new_fields.forEach(row => row['value'] = row['value'].replace(/\\/g, "\\\\"));

    let mapper_parameters = {
        "destination_table": destination_table,
        "existing_fields": JSON.stringify(g_document_mapper_table.getData("json")),
        "new_fields": JSON.stringify(table_new_fields)
    };
    mapper_parameters_json = JSON.stringify(mapper_parameters);

    return  {
        "title": mapper_name,
        "type": "Transform",
        "parameters": mapper_parameters_json
    };
}


function handle_mapper_operation_response(response) {
    console.log(typeof(response), response);
    //response is already a parsed JSON

    var mapped_dataframe = response['mapped_df'];
    g_document_mapped_dataframe_box.empty().append(mapped_dataframe);

    var mapped_transactions = response['mapped_df_json'];
    g_document_mapped_table.setData(mapped_transactions);

}


$("#btn_apply_mapper").click(function () {
    let operation = get_operation_dict_for_mapper();
    let dataframe_json = g_document_table.getData("json");

    apply_operation(operation, dataframe_json, handle_operation_response);
});

$("#btn_save_mapper").click(function() {
    let operation = get_operation_dict_for_mapper();

    save_operation(operation.title, operation.type, operation.parameters);
});

$("#btn_mapper_newfields_add_row").click(function() {
    g_document_mapper_newfields_table.addRow({});
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

            let destination_select = $("#sel-destination-schema");
            destination_select.empty();

            let new_entry_str = "new";
            destination_select.append($('<option></option>').attr('value', new_entry_str).text(new_entry_str));

            $.each(response, function (key, entry) {
                destination_select.append($('<option></option>').attr('value', entry.id).text(entry.title));
                // Create the global dictionary
                g_table_schema_dict[entry.id] = entry;
            });

            document.getElementById('input_new_schema').style.display = "";

            // console.log(g_table_schema_dict);
        }
    });
});


$("#btn_save_schema").click(function() {
    let schema_id = $("#sel-destination-schema").val();
    var schemas_url = 'http://localhost:8000/api/docminer/schemas/';
    var request_type = "POST";

    let schema_name = $("#input_new_schema").val();
    if(schema_name == "") {
        alert("Please enter Schema Name");
        return;
    }

    if (schema_id != "new") {
        schemas_url = schemas_url + schema_id + '/';
        request_type = "PUT";
    }

    let schema = {
        "title": schema_name,
        "fields_json": JSON.stringify(g_schema_table.getData("json"))
    };

    console.log(schemas_url, schema);

    $.ajax({
        type: request_type,
        url: schemas_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        data: schema,
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);

        }
    });

});


$("#btn_get_datastore_type_list").click(function () {

    let datastoretype_get_url = 'http://localhost:8000/api/docminer/datastoretypes/';

    console.log(datastoretype_get_url);

    $.ajax({
        url: datastoretype_get_url,
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

            let destination_select = $("#sel-datastore-type");
            destination_select.empty();

            let new_entry_str = "new";
            destination_select.append($('<option></option>').attr('value', new_entry_str).text(new_entry_str));

            $.each(response, function (key, entry) {
                destination_select.append($('<option></option>').attr('value', entry.id).text(entry.title));
                // Create the global dictionary

                g_table_datastoretype_parameters_description_dict[entry.id] = entry.parameters;

                console.log(typeof (entry.parameters), entry.parameters);
            });

            document.getElementById('input_new_schema').style.display = "";
        }
    });
});

let g_table_loader_dict = []

let g_table_mapper_dict = []

let g_table_extractor_dict = []

let g_table_datastore_dict = []

var g_table_schema = [];


function handle_get_loaders_response(response) {
    console.log(typeof(response), response);

    // Find the title elements of the json array received
    // e.g. schemas = ["receipt", "contract_nt", "bank_stmt"]
    let loaders = response.map(a => a.title);
    console.log(loaders);

    let loaders_select = $("#sel-loader");
    loaders_select.empty();

    let new_entry_str = "new";
    loaders_select.append($('<option></option>').attr('value', new_entry_str).text(new_entry_str));

    $.each(response, function (key, entry) {
        loaders_select.append($('<option></option>').attr('value', entry.title).text(entry.title));
        g_table_loader_dict[entry.title] = JSON.parse(entry.parameters);
    });

    document.getElementById('input_new_loader').style.display = "";
}

function handle_get_mappers_response(response) {
    console.log(typeof(response), response);

    // Find the title elements of the json array received
    // e.g. schemas = ["receipt", "contract_nt", "bank_stmt"]
    let mappers = response.map(a => a.title);
    console.log(mappers);

    let mappers_select = $("#sel-mapper");
    mappers_select.empty();

    let new_entry_str = "new";
    mappers_select.append($('<option></option>').attr('value', new_entry_str).text(new_entry_str));

    $.each(response, function (key, entry) {
        mappers_select.append($('<option></option>').attr('value', entry.title).text(entry.title));
        g_table_mapper_dict[entry.title] = JSON.parse(entry.parameters);
    });

    document.getElementById('input_new_mapper').style.display = "";
}

function handle_get_extractors_response(response) {
    console.log(typeof(response), response);

    // Find the title elements of the json array received
    // e.g. schemas = ["receipt", "contract_nt", "bank_stmt"]
    let extractors = response.map(a => a.title);
    console.log(extractors);

    let extractors_select = $("#sel-extractor");
    extractors_select.empty();

    let new_entry_str = "new";
    extractors_select.append($('<option></option>').attr('value', new_entry_str).text(new_entry_str));

    $.each(response, function (key, entry) {
        extractors_select.append($('<option></option>').attr('value', entry.title).text(entry.title));
        g_table_extractor_dict[entry.title] = JSON.parse(entry.parameters);
    });

    document.getElementById('input_new_extractor').style.display = "";
}

function fetch_operations(type, response_handler) {
    let loader_get_parameters_url = 'http://localhost:8000/api/docminer/operations/';
    let data_params = jQuery.param({type: type});

    console.log(loader_get_parameters_url, data_params);

    $.ajax({
        url: loader_get_parameters_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        data: data_params,
        dataType: 'json',
        success: function(response) {
            response_handler(response);
        }
    });
}

$("#btn_get_loaders").click(function () {
    fetch_operations("Load", handle_get_loaders_response);
});

$("#btn_get_mappers").click(function () {
    // First get the dependency
    $("#btn_get_schema_list").click();

    fetch_operations("Transform", handle_get_mappers_response);
});

$("#btn_get_extractors").click(function () {
    // First get the dependency
    $("#btn_get_datastores").click();

    fetch_operations("Extract", handle_get_extractors_response);
});


$("#btn_get_datastores").click(function () {
    // First get the dependency
    $("#btn_get_datastore_type_list").click();

    let loader_get_datastores_url = 'http://localhost:8000/api/docminer/datastores/';
    console.log(loader_get_datastores_url);

    $.ajax({
        url: loader_get_datastores_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);

            // Find the title elements of the json array received
            // e.g. schemas = ["receipt", "contract_nt", "bank_stmt"]
            let datastores = response.map(a => a.title);
            console.log(datastores);

            let datastores_select = $("#sel-datastore");
            datastores_select.empty();

            let new_entry_str = "new";
            datastores_select.append($('<option></option>').attr('value', new_entry_str).text(new_entry_str));

            $.each(response, function (key, entry) {
                datastores_select.append($('<option></option>').attr('value', entry.id).text(entry.title));
                g_table_datastore_dict[entry.id] = entry;
            });

            document.getElementById('input_new_datastore').style.display = "";
        }
    });
});


function get_operation_dict_for_loader() {
    // Get document id
    let datastore_name = $("#input_new_loader").val();
    if (datastore_name == "") {
        alert('Please provide datastore name!');
        return;
    }

    let datastore_table = $("#input_datastore_table").val();
    if (datastore_table == "") {
        alert('Please provide table name!');
        return;
    }

    let datastore_id = $("#sel-datastore").val();
    let loader = {
        "table": datastore_table,
        "datastore_id": datastore_id
    };
    let loader_parameters_json = JSON.stringify(loader);

    return {
        "title": datastore_name,
        "type": "Load",
        "parameters": loader_parameters_json
    };
}

// Keep this for later
$("#btn_save_loader").click(function() {
    let operation = get_operation_dict_for_loader();

    save_operation(operation.title, operation.type, operation.parameters);
});

function fill_datastore_from_id(datastore_id) {
    console.log(datastore_id);

    let loader_get_datastores_url = 'http://localhost:8000/api/docminer/datastores/' + datastore_id + '/';
    $.ajax({
        url: loader_get_datastores_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);

            let select_datastore = document.getElementById('sel-datastore');
            select_datastore.value = response.id;

            let event = new Event('change');
            select_datastore.dispatchEvent(event);
        }
    });
}

function set_selector_value_with_event(sel_id, value) {
    let select_extractor_type = document.getElementById(sel_id);
    select_extractor_type.value = value;
    select_extractor_type.dispatchEvent(new Event('change'));
}

// TBD: Ensure that the sel-datastore is already populated
function fill_loader_from_operation_dict(operation) {
    console.log(operation);
    $("#input_datastore_table").val(operation.table);
    fill_datastore_from_id(operation.datastore_id);
}

// TBD: Ensure that the sel-destination-schema is already populated
function fill_mapper_from_operation_dict(operation) {
    console.log(operation);

    set_selector_value_with_event('sel-destination-schema', operation.destination_table);
    g_document_mapper_table.setData(operation.existing_fields);

    let table_new_fields = JSON.parse(operation.new_fields);
    table_new_fields.forEach(row => row['value'] = row['value'].replace(/\\\\/g, "\\"));
    g_document_mapper_newfields_table.setData(table_new_fields);
}


function fill_extractor_from_operation_dict(operation) {
    console.log(operation);

    set_selector_value_with_event('sel-extractor-type', operation.type)

    document.getElementById('regex-text').value = operation.parameters.regex;
}


$("#sel-loader").on('change', function() {
    let loader_name = this.value;
    let loader_parameters = g_table_loader_dict[loader_name];

    if (loader_name == "new") {
        g_account_parameters_value_table.setData(g_table_datastore_parameters_values_array);
    } else {
        console.log(loader_name, loader_parameters);

        $("#input_new_loader").val(loader_name);
        fill_loader_from_operation_dict(loader_parameters);
    }
});


$("#sel-mapper").on('change', function() {
    let mapper_name = this.value;
    let mapper_parameters = g_table_mapper_dict[mapper_name];

    if (mapper_name == "new") {
        g_account_parameters_value_table.setData(g_table_datastore_parameters_values_array);
    } else {
        console.log(mapper_name, mapper_parameters);

        $("#input_new_mapper").val(mapper_name);
        fill_mapper_from_operation_dict(mapper_parameters);
    }
});

$("#sel-extractor").on('change', function() {
    let extractor_name = this.value;
    let extractor_parameters = g_table_extractor_dict[extractor_name];

    if (extractor_name == "new") {
        g_account_parameters_value_table.setData(g_table_datastore_parameters_values_array);
    } else {
        console.log(extractor_name, extractor_parameters);

        $("#input_new_extractor").val(extractor_name);
        fill_extractor_from_operation_dict(extractor_parameters);
    }
});


$("#btn_save_datastore").click(function() {
    // Get document id
    let datastore_name = $("#input_new_datastore").val();
    if (datastore_name == "") {
        alert('Please provide datastore name!');
        return;
    }

    let store_type = $("#sel-datastore-type").val();
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

    // save_operation("S1", "Load", "{}");
    let datastore = {
        "title": datastore_name,
        "type": store_type,
        "parameters": JSON.stringify(final_store_parameters_values)

    };

    let datastores_url = 'http://localhost:8000/api/docminer/datastores/';

    $.ajax({
        type: 'POST',
        data: datastore,
        url: datastores_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);
        }
    });

});

$("#sel-datastore").on('change', function() {
    let datastore_name = this.value;

    if (datastore_name == "new") {
        let datastore_type = $("#sel-datastore-type").val();

        if (datastore_type != "new") {
            let parameters_array_json = g_table_datastoretype_parameters_description_dict[datastore_type];
            console.log(parameters_array_json);

            let parameters = JSON.parse(parameters_array_json);
            let parameter_names = parameters.map(a => a.name);
            console.log(parameter_names);

            // In the value we can provide the default value
            g_table_datastore_parameters_values_array = parameters.map(function (parameter) {
                return {"parameter": parameter.name, "value": ""};
            });
        }
    } else {
        let datastore = g_table_datastore_dict[datastore_name];
        let parameters = JSON.parse(datastore.parameters);

        g_table_datastore_parameters_values_array.length = 0;
        for (var key in parameters) {
            // check if the property/key is defined in the object itself, not in parent
            if (parameters.hasOwnProperty(key)) {
                g_table_datastore_parameters_values_array.push({"parameter": key, "value":  parameters[key]});
            }
        }

        set_selector_value_with_event('sel-datastore-type', datastore.type);
    }

    g_account_parameters_value_table.setData(g_table_datastore_parameters_values_array);
});


$("#sel-datastore-type").on('change', function() {

    if (this.value == "new") {
        g_account_parameters_description_table.setData('[]')
    } else {

        g_account_parameters_description_table.setData(g_table_datastoretype_parameters_description_dict[this.value]);
    }
});

$("#btn_upload_datastore").click(function () {
    g_account_parameters_value_table.setDataFromLocalFile();
});

$("#btn_download_datastore").click(function () {
    g_account_parameters_value_table.download("json", "datastore.json");
});


function apply_operation(operation, dataframe_json, success_callback) {
    let operation_apply_url = 'http://localhost:8000/api/docminer/operations/apply/';

    console.log(operation_apply_url, operation, dataframe_json);

    $.ajax({
        type: 'POST',
        url: operation_apply_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        data: {
            "operation_params": JSON.stringify(operation),
            "dataframe_json": JSON.stringify(dataframe_json)
        },
        success: function(response) {
            console.log(typeof(response), response);

            success_callback(operation, response);
        }
    });

}

function handle_loader_operation_response(response) {
    console.log(response);

}

$("#btn_apply_loader").click(function () {
    let operation = get_operation_dict_for_loader();
    let dataframe_json = g_document_mapped_table.getData("json");

    apply_operation(operation, dataframe_json, handle_operation_response)
});



var g_flag_pipeline_active = false;
let g_operations_array = [];
var g_operation_array_current_index = 0;
var g_pipeline_completion_handler;

let g_table_pipeline_dict = {};

$("#btn_get_pipelines").click(function () {

    // First make the dependency requests
    $("#btn_get_extractors").click();
    $("#btn_get_mappers").click();
    $("#btn_get_loaders").click();

    let pipeline_get_url = 'http://localhost:8000/api/docminer/pipelines/';

    console.log(pipeline_get_url);

    $.ajax({
        url: pipeline_get_url,
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

            let destination_select = $("#sel-pipeline");
            destination_select.empty();

            let new_entry_str = "new";
            destination_select.append($('<option></option>').attr('value', new_entry_str).text(new_entry_str));

            $.each(response, function (key, entry) {
                destination_select.append($('<option></option>').attr('value', entry.id).text(entry.title));

                g_table_pipeline_dict[entry.id] = entry;
            });

            document.getElementById('input_new_schema').style.display = "";
        }
    });
});

function perform_pipeline_operation() {
    if (g_operation_array_current_index >= g_operations_array.length) {
        g_flag_pipeline_active = false;

        g_pipeline_completion_handler({});
        g_pipeline_completion_handler = undefined;
        return;
    }

    let operation = g_operations_array[g_operation_array_current_index++];
    console.log(operation);

    if (operation.type == "Extract") {
        $("#btn_apply_extractor").click();
    } else if (operation.type == "Transform") {
        $("#btn_apply_mapper").click();
    } else if (operation.type == "Load") {
        $("#btn_apply_loader").click();
    }
}

function handle_pipeline_execution_complete(response) {
    console.log("Pipeline Execution Completed", response);

    if ($("#sel-loader").val() != "new") {
        $("#btn_get_final_table").click();
    }
}

function execute_pipeline(completion_handler) {
    g_flag_pipeline_active = true;
    g_operation_array_current_index = 0;
    g_pipeline_completion_handler = completion_handler;

    perform_pipeline_operation();
}

$("#btn_apply_pipeline").click(function () {
    console.log(g_operations_array);

    execute_pipeline(handle_pipeline_execution_complete);
});


function operation_response_handler(response) {
    console.log(response);

    g_operations_array.push(response);

    if (response.type == "Extract") {
        set_selector_value_with_event('sel-extractor', response.title);
    } else if (response.type == "Transform") {
        set_selector_value_with_event('sel-mapper', response.title);
    } else if (response.type == "Load") {
        set_selector_value_with_event('sel-loader', response.title);
    }

    if (g_operation_array_current_index < g_operation_pipeline_array.length) {
        fetch_operation_by_id(g_operation_pipeline_array[g_operation_array_current_index++],
            operation_response_handler);
    }
}

function fetch_operation_by_id(id, response_handler) {
    console.log(g_operation_array_current_index);

    let loader_get_parameters_url = 'http://localhost:8000/api/docminer/operations/' + id + '/';
    console.log(loader_get_parameters_url);

    $.ajax({
        url: loader_get_parameters_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            response_handler(response);
        }
    });
}

$("#sel-pipeline").on('change', function() {
    let pipeline_id = this.value;
    let pipeline =  g_table_pipeline_dict[pipeline_id];

    console.log(pipeline_id, pipeline, pipeline.operations, pipeline.operations_json);

    g_operations_array.length = 0;
    g_operation_pipeline_array = JSON.parse(pipeline.operations_json);
    g_operation_array_current_index = 0;

    fetch_operation_by_id(g_operation_pipeline_array[g_operation_array_current_index++],
        operation_response_handler);
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
        "operations": g_operation_pipeline_array,
        "operations_json": JSON.stringify(g_operation_pipeline_array),
    });

    console.log("json_data:" + json_data);

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

$("#btn_reset_pipeline").click(function () {
    g_operation_pipeline_array.length = 0;

    console.log("Pipeline_array:", g_operation_pipeline_array);
});


function handle_get_table(operation, response) {
    console.log(response);

    // Account table which shows transactions in all the documents uploaded for an account
    let final_table = new Tabulator("#final-table", {
        height:300,
        layout:"fitData", //fit columns to width of table (optional)
        autoColumns:true,
        movableColumns: true,

        rowClick: function(e, row){ //trigger an alert message when the row is clicked
            alert('Row index ' + row.getPosition() + ' clicked');
        },
    });
    final_table.setData(response['transactions']);
}

$("#btn_get_final_table").click(function() {
    // We are using the following function to reuse the code
    let load_operation = get_operation_dict_for_loader();
    let database_parameters = load_operation.parameters;
    console.log(database_parameters);

    let new_parameters = {
        "type": "database",
        "parameters": database_parameters
    };

    let operation = {
        "type": "Extract",
        "parameters": JSON.stringify(new_parameters)
    };
    let dataframe = [];
    apply_operation(operation, dataframe, handle_get_table)
});


$(document).ready(function() {
    $("#btn_get_pipelines").click();
});


