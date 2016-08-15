#!/bin/bash
TOKEN=$(/bin/cat ./TOKEN)
HOST="https://api.pinterest.com"
PATH="/v1/boards/$1/$2/pins/"
QUERY="access_token=$TOKEN&fields=id%2Cimage"
URI="$HOST$PATH?$QUERY"
if [[ $1 == *"cursor"* ]]
then
    OUT=$(/usr/bin/curl $1 2>/dev/null)
else
    OUT=$(/usr/bin/curl $URI 2>/dev/null)
fi
PARSED=$(echo $OUT | /bin/sed 's/https/\nhttps/g' | /bin/sed 's/".*//g')
for item in $PARSED
do
    if [[ $item == *"pinimg"* ]]
    then
        /usr/bin/curl -O $item 2>/dev/null
    elif [[ $item == *"cursor"* ]]
    then
        $0 $item
    elif [[ $item == "{" ]]
    then
        echo Found new file
    else
        echo What is $item
    fi
done
