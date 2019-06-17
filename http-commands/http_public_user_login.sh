DEBUG=0

FLAGS=""

if [ $DEBUG -gt 0 ]
then
  FLAGS="${FLAGS} --debug"
fi

http ${FLAGS} --json POST http://localhost:8000/api/user/token/ <<< '{ "email": "alice@abc.com",  "password": "Alice123" }'

# http post http://127.0.0.1:8000/api-token-auth/ username=alice@abc.com password=Alice123
