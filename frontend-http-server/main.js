// Document table which shows transactions present in a document
let g_document_table = new Tabulator("#document-transactions-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)
    autoColumns:true,

    rowClick: function(e, row){ //trigger an alert message when the row is clicked
        alert('Row index ' + row.getPosition() + ' clicked');
    },
});

// Regex transactions table which shows transactions extracted by the generated regex
let g_regex_transactions_table = new Tabulator("#regex-transactions-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)
    autoColumns:true,

    rowClick: function(e, row){ //trigger an alert message when the row is clicked
        alert('Row index ' + row.getPosition() + ' clicked');
    },
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
let g_document_pandas_box = $("#document-pandas");

// MacPro Docker
let g_user_auth_token_docker = '307e60bcf5f1930b39a6ce5bc87b171ed0451323';
// MacPro Local
let g_user_auth_token_local = '219201bc10fb6baa4a4cbc36d318aedaa89f78b7';
// MacAir Local
// let g_user_auth_token_local = '0676010d893a1e1cd15f5d8a3883b5ced174fdad';


var g_current_document = null;
var g_current_document_local_cache = {};

var flag_server_local = true;

var g_user_auth_token = g_user_auth_token_docker;
if (flag_server_local) {
    g_user_auth_token = g_user_auth_token_local;
}


// These functions should have no knowledge of elements extractions
//
function set_sample_transactions(tabulator_table) {
    tabulator_table.setData(credit_card_data);
}

function download_document_transactions(user_auth_token, document_id, tabulator_table, elm_text_box, elm_pandas_box) {
    if (document_id == "") {
        alert("Please provide a valid document Id");
        return;
    }

    // http://localhost:8000/api/docminer/documents/<document_id>/
    let document_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/';

    $.ajax({
        url: document_url,
        headers : {
            'Authorization' : 'Token ' + user_auth_token,
        },
        dataType: 'json',
        success: function(document) {
            g_current_document = document;

            // console.log(typeof(document), document);
            elm_text_box.empty().append(document.text);
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

            tabulator_table.setData(response);
        }
    });

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_transactions_pandas_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/dataframe/';

    $.ajax({
        url: document_transactions_pandas_url,
        headers : {
            'Authorization' : 'Token ' + user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            // console.log(typeof(response), response);
            //response is already a parsed JSON

            elm_pandas_box.empty().append(response);
        }
    });
}


// These function deal with the elements
//
function download_document_using_input(tabulator_table, user_auth_token) {
    let document_id = $("#input_document_id").val();

    download_document_transactions(user_auth_token,
        document_id, tabulator_table, g_document_text_box, g_document_pandas_box);
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
                $("#btn_download").click();
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

    console.log(document_row_url);

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
            g_document_text_box.empty().append(new_str);

            var regex_str = response[0]['regex'];
            // console.log(regex_str)
            // display_regex_str = regex_str.replaceAll("<", "{").replaceAll(">", "}");
            // g_regex_text_box.value = display_regex_str;
            document.getElementById('regex-text').value = regex_str;
            g_current_document_local_cache['regex_str'] = regex_str;

            var transactions = response[0]['transactions'];
            g_regex_transactions_table.setData(transactions);
        }
    });

});

$("#btn_reset_text").click(function() {
    g_document_text_box.empty().append(g_current_document.text);
});


$("#btn_apply_regex").click(function() {
    // Get document id
    let document_id = $("#input_document_id").val();

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_row_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/regex/apply/';

    console.log(document_row_url);

    var regex_text = g_regex_text_box.val();
    // var complete_text = g_document_text_box.val();
    var complete_text = g_current_document.text;

    // console.log("Complete Text:\n" + complete_text);

    $.ajax({
        type: 'POST',
        url: document_row_url,
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

            var transactions = response[0]['transactions'];
            g_regex_transactions_table.setData(transactions);
        }
    });

});

$("#btn_reset_regex").click(function() {
    document.getElementById('regex-text').value = g_current_document_local_cache['regex_str'];
});


$("#btn_download").click(function() {
    download_document_using_input(g_document_table, g_user_auth_token);

    // set_sample_transactions(g_document_table);
});

$("#btn_download_excel").click(function () {
    g_document_table.download("csv", "trades.csv");
});

$("#btn_documentize").click(function() {
    var file_id = $("#input_file_id").val();
    input_document_elm = $("#input_document_id");
    documentize_file(g_user_auth_token, file_id, input_document_elm);
});

$("#btn_save_snowflake").click(function () {
    // Get document id
    let document_id = $("#input_document_id").val();

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_transactions_save_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/save/';

    console.log(document_transactions_save_url);

    $.ajax({
        url: document_transactions_save_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            // console.log(typeof(response), response);
            //response is already a parsed JSON

            // alert("Transactions saved");
            g_account_table.setData(response);
        }
    });

});

$("#fileinfo").submit(function(e) {
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
            // alert('File upload successful (id = ' + response.id + ')');
            $("#input_file_id").val(response.id);
            if (g_config_automate_flow) {
                $("#btn_documentize").click();
            }
        },
    });
    e.preventDefault();
});

$(document).ready(function() {
    download_document_using_input(g_document_table, g_user_auth_token);
});


