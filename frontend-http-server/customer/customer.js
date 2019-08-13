let g_customer_automate_workflow = true;

// Document table which shows transactions present in a document
let g_customer_transactions_table = new Tabulator("#customer-transactions-table", {
    height:300,
    layout:"fillData",
    layoutColumnsOnNewData:true,
    autoColumns:true,

    rowClick: function(e, row){ //trigger an alert message when the row is clicked
        alert('Row index ' + row.getPosition() + ' clicked');
    },
});

var g_customer_file_info = {};

$("#customer-fileinfo").submit(function(e) {
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
            g_customer_file_info = response;
            console.log(g_customer_file_info);

            if (g_customer_automate_workflow) {
                $("#input_file_id").val(g_customer_file_info.id);
                $("#btn_apply_pipeline").click();
            }
        },
    });
});

function get_pipelines() {
    let pipelines_get_url = 'http://localhost:8000/api/docminer/pipelines/';
    console.log(pipelines_get_url);

    $.ajax({
        url: pipelines_get_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);


            // Find the title elements of the json array received
            // e.g. schemas = ["receipt", "contract_nt", "bank_stmt"]
            let pipeline_titles = response.map(a => a.title);

            console.log(pipeline_titles);

            let pipeline_select = $("#sel-pipeline");
            pipeline_select.empty();


            $.each(response, function (key, entry) {
                pipeline_select.append($('<option></option>').attr('value', entry.id).text(entry.title));
            });

            // console.log(g_table_schema_dict);
        }
    });

}

$("#btn_apply_pipeline").click(function() {
    let input_file_id = $("#input_file_id").val();
    let pipeline_id = $("#sel-pipeline").val();

    console.log(pipeline_id);

    let pipelines_apply_url = 'http://localhost:8000/api/docminer/pipelines/apply/';

    $.ajax({
        type:'POST',
        url: pipelines_apply_url,
        headers : {
            'Authorization' : 'Token ' + g_user_auth_token,
        },
        data: {
            "file_id": input_file_id,
            "pipeline_id": pipeline_id
        },
        dataType: 'json',
        success: function(response) {
            console.log(typeof(response), response);

            g_customer_transactions_table.setData(response.table_json);
        }
    });

});


$(document).ready(function() {
    get_pipelines();
});