AUTH_TOKEN="864556deab19c0b84c28d1a56b20c2c3808c9099"
DOCUMENT_ID=1
DEBUG=0

FLAGS=""

if [ $DEBUG -gt 0 ]
then
  FLAGS="${FLAGS} --debug"
fi

# Get the transactions in json format
http ${FLAGS} "http://localhost:8000/api/docminer/documents/${DOCUMENT_ID}/transactions/json/" "Authorization:Token ${AUTH_TOKEN}"
