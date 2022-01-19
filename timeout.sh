#!/usr/bin/env sh

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
        kill -TERM $(ps -o pid= --ppid "$TIMEOUT_PID_COMMAND") 2>/dev/null
    fi

    if test ! -z "$TIMEOUT_PID_TIMEOUT"; then
        kill -TERM $(ps -o pid= --ppid "$TIMEOUT_PID_TIMEOUT") 2>/dev/null
    fi
}

trap timeout_cleanup TERM

timeout "$@"
