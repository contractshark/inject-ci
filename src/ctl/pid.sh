#!/bin/bash

interact() {
    pid=$1
    ! ps -p "$pid" && return
    ls -ld /proc/"$pid"/fd/*
    sleep 5; kill -1 "$pid"   # TEST SIGNAL TO PARENT
}

run() {
    exec {in}<&0 {out}>&1 {err}>&2
    { coproc "$@" 0<&$in 1>&$out 2>&$err; } 2>/dev/null
    exec {in}<&- {out}>&- {err}>&-
    { interact $! <&- >/tmp/whatever.log 2>&1& } 2>/dev/null
    fg %1 >/dev/null 2>&1
    wait 2>/dev/null
}
