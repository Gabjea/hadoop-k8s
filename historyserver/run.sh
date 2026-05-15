#!/bin/bash

# Force the State Store to use FileSystem instead of LevelDB
export YARN_CONF_yarn_timeline___service_state___store___class=org.apache.hadoop.yarn.server.timeline.recovery.FileSystemTimelineStateStore

# Double check your store class is properly overriding the default
export YARN_CONF_yarn_timeline___service_store___class=org.apache.hadoop.yarn.server.timeline.FileSystemTimelineStore

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR historyserver