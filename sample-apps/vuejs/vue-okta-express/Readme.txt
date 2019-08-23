# https://developer.okta.com/blog/2018/02/15/build-crud-app-vuejs-node

vue init pwa front-vue
cd ./frontend-vue
npm install
npm run dev

npm i bootstrap-vue@2.0.0-rc.7 bootstrap@4.1.0
npm i @okta/okta-vue@1.0.0


mkdir backend-express
cd backend-express
npm i express@4.16.3 cors@2.8.4 @okta/jwt-verifier@0.0.11 sequelize@4.37.6 sqlite3@4.0.0 epilogue@0.7.1 axios@0.18.0
node ./src/server
