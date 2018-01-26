#!/usr/bin/env bash

PID_FILE=/var/run/jupyter.pid
LOG_FILE=/var/log/jupyter.log

if [ -f $PID_FILE ]; then
  JPID=$(cat $PID_FILE )
  echo "Stop Jupyter Service..."
  kill -SIGINT $JPID
  rm -rf $PID_FILE
  echo "Log File: $LOG_FILE"
  echo "Latest Logs: "
  tail -n 10 $LOG_FILE
else
  echo "Stop Jupyter Failed: Pid File Not Found"
fi
