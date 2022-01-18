#!/usr/bin/env sh

TIMEOUT_PID_COMMAND=""
TIMEOUT_PID_TIMEOUT=""

timeout() {
    TIMEOUT_SLEEP="$1"
    shift 1
    ("$@"; kill -TERM $$) &
    TIMEOUT_PID_COMMAND=$!
    (sleep "$TIMEOUT_SLEEP"; echo "Timeout."; kill -TERM $$) &
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

timeout "$@"
