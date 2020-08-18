
var flag_server_local = true;

// MacPro Docker
let g_user_auth_token_docker = '307e60bcf5f1930b39a6ce5bc87b171ed0451323';
// MacPro Local : Received using postman api
// let g_user_auth_token_local = '2d3fe956e20b609f91c3afb3b6285a7b82737c29';
// MacAir Local
let g_user_auth_token_local = '92147124584234cfbf6186f46a766c7eebe7e91c';

var g_user_auth_token = g_user_auth_token_docker;
if (flag_server_local) {
    g_user_auth_token = g_user_auth_token_local;
}
