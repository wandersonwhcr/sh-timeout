#!/usr/bin/env sh

timeout() {
    TIMEOUT_SLEEP="$1"
    shift 1

    (sleep "$TIMEOUT_SLEEP"; echo "Timeout.") &
    TIMEOUT_PID_TIMEOUT=$!

    ("$@"; ps -o pid= --ppid "$TIMEOUT_PID_TIMEOUT" | xargs --no-run-if-empty kill -TERM) &
    TIMEOUT_PID_COMMAND=$!

    wait "$TIMEOUT_PID_TIMEOUT"

    ps -o pid= --ppid "$TIMEOUT_PID_COMMAND" | xargs --no-run-if-empty kill -TERM
}

timeout "$@"
