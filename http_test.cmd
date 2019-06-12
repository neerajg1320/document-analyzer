AUTH_TOKEN="fa29e9f02c45527ac658515d20ac49e2b41e6da5"

# Get the transactions in json format
http --debug http://localhost:8000/api/docminer/documents/21/transactions/json/ "Authorization:Token ${AUTH_TOKEN}"
