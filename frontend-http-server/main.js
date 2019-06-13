//create Tabulator on DOM element with id "example-table"
let g_tabulator_table = new Tabulator("#transactions-table", {
    height:300,
    layout:"fitColumns", //fit columns to width of table (optional)
    autoColumns:true,

    rowClick:function(e, row){ //trigger an alert message when the row is clicked
        alert("Row " + row + " Clicked!!!!");
    },
});


// These functions should have no knowledge of elements extractions
//
function set_sample_transactions(tabulator_table) {
    tabulator_table.setData(credit_card_data);
}

function download_document_transactions(tabulator_table, document_id) {
    if (document_id == "") {
        alert("Please provide a valid document Id");
        return;
    }

    // http://localhost:8000/api/docminer/documents/<document_id>/transactions/json/
    let document_json_url = 'http://localhost:8000/api/docminer/documents/' + document_id + '/transactions/json/';

    $.getJSON(document_json_url, function(response) {
        console.log(typeof(response), response);
        //response is already a parsed JSON

        tabulator_table.setData(response);
    });
}


// These function deal with the elements
//
function download_document_using_input(tabulator_table) {
    document_id = $("#input_document_id").val();

    download_document_transactions(tabulator_table, document_id)
}


$("#btn_download").click(function() {
    download_document_using_input(g_tabulator_table);

    // set_sample_transactions(g_tabulator_table);
});


$(document).ready(function() {
    download_document_using_input(g_tabulator_table);
});

// http://localhost:8000/api/docminer/documents/22/highlight/

