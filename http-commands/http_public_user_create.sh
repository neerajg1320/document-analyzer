DEBUG=0

FLAGS=""

if [ $DEBUG -gt 0 ]
then
  FLAGS="${FLAGS} --debug"
fi

http ${FLAGS} --json POST http://localhost:8000/api/user/create/ <<< '{ "email": "bob@abc.com", "name": "Bob", "password": "Bob123" }'

# The following also works
# echo '{ "email": "alice@abc.com", "name": "Alice", "password": "Alice123" }' | http --debug --json POST http://localhost:8000/api/user/create/ 
