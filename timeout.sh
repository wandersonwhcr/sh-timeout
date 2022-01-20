#!/usr/bin/env sh

timeout() {
    TIMEOUT_SLEEP="$1"
    shift 1

    (sleep "$TIMEOUT_SLEEP"; echo "Timeout.") &
    TIMEOUT_PID_TIMEOUT=$!

    ("$@"; timeout_cleanup "$TIMEOUT_PID_TIMEOUT") &
    TIMEOUT_PID_COMMAND=$!

    wait "$TIMEOUT_PID_TIMEOUT"

    timeout_cleanup "$TIMEOUT_PID_COMMAND"
}

timeout_cleanup() {
    ps -o pid= --ppid "$1" | xargs -r kill -TERM
}

timeout "$@"
