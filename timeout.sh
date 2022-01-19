#!/usr/bin/env sh

timeout() {
    TIMEOUT_SLEEP="$1"

    shift 1

    (sleep "$TIMEOUT_SLEEP"; echo "Timeout.") &
    TIMEOUT_PID_TIMEOUT=$!

    ("$@"; kill -TERM "$TIMEOUT_PID_TIMEOUT" 2>/dev/null) &
    TIMEOUT_PID_COMMAND=$!

    wait "$TIMEOUT_PID_TIMEOUT" 2>/dev/null

    kill -TERM "$TIMEOUT_PID_COMMAND" 2>/dev/null
}

timeout "$@"
