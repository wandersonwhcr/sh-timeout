#!/usr/bin/env sh

TIMEOUT_PID_COMMAND=""
TIMEOUT_PID_TIMEOUT=""

timeout() {
    (sleep 10; kill -TERM $$) &
    TIMEOUT_PID_COMMAND=$!
    (sleep 5; echo "Timeout."; kill -TERM $$) &
    TIMEOUT_PID_TIMEOUT=$!

    wait
}

timeout_cleanup() {
    if test ! -z "$TIMEOUT_PID_COMMAND"; then
        kill -TERM "$TIMEOUT_PID_COMMAND"
    fi

    if test ! -z "$TIMEOUT_PID_TIMEOUT"; then
        kill -TERM "$TIMEOUT_PID_TIMEOUT"
    fi
}

trap timeout_cleanup TERM

timeout
