#!/usr/bin/env sh

cleanup() {
    kill -TERM "$PIDCOMMAND" "$PIDTIMEOUT"
}

trap cleanup TERM

(sleep 5; kill -TERM $$) &
PIDCOMMAND=$!
(sleep 10; echo "Timeout"; kill -TERM $$) &
PIDTIMEOUT=$!

wait
