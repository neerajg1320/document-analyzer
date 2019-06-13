AUTH_TOKEN="eb145cd8b9c3a7a142d914b8cb8c949e6a1137d5"

# Get the transactions in json format
http --debug http://localhost:8000/api/docminer/documents/21/transactions/json/ "Authorization:Token ${AUTH_TOKEN}"
