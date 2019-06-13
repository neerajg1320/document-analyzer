//create Tabulator on DOM element with id "example-table"
let g_tabulator_table = new Tabulator("#transactions-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)
    autoColumns:true,

    rowClick:function(e, row){ //trigger an alert message when the row is clicked
        alert("Row " + row + " Clicked!!!!");
    },
});


let g_user_auth_token = '864556deab19c0b84c28d1a56b20c2c3808c9099';


// These functions should have no knowledge of elements extractions
//
function set_sample_transactions(tabulator_table) {
    tabulator_table.setData(credit_card_data);
}

function download_document_transactions(tabulator_table, document_id, user_auth_token) {
    if (document_id == "") {
        alert("Please provide a valid document Id");
        return;
    }

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_json_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/json/';

    $.ajax({
        url: document_json_url,
        headers : {
            'Authorization' : 'Token ' + user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);
            //response is already a parsed JSON

            tabulator_table.setData(response);
        }
    });
}


// These function deal with the elements
//
function download_document_using_input(tabulator_table, user_auth_token) {
    document_id = $("#input_document_id").val();

    download_document_transactions(tabulator_table, document_id, user_auth_token)
}


$("#btn_download").click(function() {
    download_document_using_input(g_tabulator_table, g_user_auth_token);

    // set_sample_transactions(g_tabulator_table);
});


$(document).ready(function() {
    download_document_using_input(g_tabulator_table, g_user_auth_token);
});

// http://localhost:8000/api/docminer/documents/22/highlight/

