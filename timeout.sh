#!/usr/bin/env sh

timeout() {
    timeout_sleep "$1" &
    TIMEOUT_PID_TIMEOUT=$!
    shift 1

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
    TIMEOUT_SLEEP="$1"
    sleep "$TIMEOUT_SLEEP" >/dev/null 2>&1
    TIMEOUT_RC_TIMEOUT="$?"
    if test "$TIMEOUT_RC_TIMEOUT" -eq 0; then
        echo "Timeout." >&2
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
    for CHILD in $(ps -o pid= --ppid "$1"); do
        kill -TERM "$CHILD"
    done
}

timeout "$@"
