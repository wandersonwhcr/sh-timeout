#!/usr/bin/env sh

timeout() {
    TIMEOUT_SLEEP="$1"
    shift 1

    timeout_sleep &
    TIMEOUT_PID_TIMEOUT=$!

    timeout_command "$TIMEOUT_PID_TIMEOUT" "$@" &
    TIMEOUT_PID_COMMAND=$!

    wait "$TIMEOUT_PID_TIMEOUT"
    TIMEOUT_RC_TIMEOUT="$?"

    timeout_cleanup "$TIMEOUT_PID_COMMAND"

    wait "$TIMEOUT_PID_COMMAND"
    TIMEOUT_RC_COMMAND="$?"

    echo "TIMEOUT_RC_TIMEOUT $TIMEOUT_RC_TIMEOUT"
    echo "TIMEOUT_RC_COMMAND $TIMEOUT_RC_COMMAND"
}

timeout_sleep() {
    sleep "$TIMEOUT_SLEEP" && (echo "Timeout." >&1)
    TIMEOUT_RC_TIMEOUT="$?"
    return "$TIMEOUT_RC_TIMEOUT"
}

timeout_command() {
    TIMEOUT_PID_TIMEOUT="$1"
    shift 1
    "$@"
    TIMEOUT_RC_COMMAND="$?"
    timeout_cleanup "$TIMEOUT_PID_TIMEOUT"
    return "$TIMEOUT_RC_COMMAND"
}

timeout_cleanup() {
    ps -o pid= --ppid "$1" | xargs -r kill -TERM
}

timeout "$@"
