//create Tabulator on DOM element with id "example-table"
let g_tabulator_table = new Tabulator("#document-transactions-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)
    autoColumns:true,

    rowClick: function(e, row){ //trigger an alert message when the row is clicked
        alert('Row index ' + row.getPosition() + ' clicked');
    },
});

let g_document_text_box = $("#document-text")
let g_document_pandas_box = $("#document-pandas")

// MacPro Docker
let g_user_auth_token_docker = '307e60bcf5f1930b39a6ce5bc87b171ed0451323';
// MacPro Local
let g_user_auth_token_local = '219201bc10fb6baa4a4cbc36d318aedaa89f78b7';
// MacAir Local
// let g_user_auth_token_docker = '0676010d893a1e1cd15f5d8a3883b5ced174fdad';



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
    let document_transactions_pandas_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/pandas/';

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

    download_document_transactions(user_auth_token, document_id, tabulator_table, g_document_text_box, g_document_pandas_box);
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
            $("#btn_download").click();
        }
    });
}


$("#btn_load_file").click(function() {
    g_tabulator_table.setDataFromLocalFile(".json");
});


$("#btn_download").click(function() {
    download_document_using_input(g_tabulator_table, g_user_auth_token);

    // set_sample_transactions(g_tabulator_table);
});


$("#btn_documentize").click(function() {
    var file_id = $("#input_file_id").val();
    input_document_elm = $("#input_document_id");
    documentize_file(g_user_auth_token, file_id, input_document_elm);
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
            $("#btn_documentize").click();
        },
    });
    e.preventDefault();
});

$(document).ready(function() {
    download_document_using_input(g_tabulator_table, g_user_auth_token);
});


