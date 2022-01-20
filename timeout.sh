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

    return "$TIMEOUT_RC_COMMAND"
}

timeout_sleep() {
    sleep "$TIMEOUT_SLEEP" >/dev/null 2>&1
    TIMEOUT_RC_TIMEOUT="$?"
    if test "$TIMEOUT_RC_TIMEOUT" -eq 0; then
        echo "Timeout." >&1
    fi
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
