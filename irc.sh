#!/bin/bash
server="nightride.fm"
channel="#rekt"
encryption="aes-256-cbc"
password="password"
nc $server 6667 | while read ircmsg; do
    echo $ircmsg
    if [[ $ircmsg == PING* ]]; then
        echo "PONG ${ircmsg#PING :}" >&2
    fi
    if [[ $ircmsg == *"PRIVMSG"* ]]; then
        username=${ircmsg%!*}
        username=${username#:}
        message=${ircmsg#*PRIVMSG}
        message=${message#* :}
        echo "<$username> $message"
    fi
    if [[ $ircmsg == *"001"* ]]; then
        echo "JOIN $channel" >&2
        echo "PRIVMSG $channel :Hello this is 142" >&2
    fi
    echo -n "Enter message to send to $channel: "
    read -s message
    encrypted_message=$(echo "$message" | openssl enc -e -$encryption -a -A -k $password)
    echo "PRIVMSG $channel :$encrypted_message" >&2
done
