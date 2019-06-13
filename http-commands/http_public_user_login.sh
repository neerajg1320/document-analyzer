DEBUG=0

FLAGS=""

if [ $DEBUG -gt 0 ]
then
  FLAGS="${FLAGS} --debug"
fi

http ${FLAGS} --json POST http://localhost:8000/api/user/token/ <<< '{ "email": "alice@abc.com",  "password": "Alice123" }'
