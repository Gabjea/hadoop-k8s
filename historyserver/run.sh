#!/bin/bash

# The state store can safely remain FileSystem (it is pure Java)
export YARN_CONF_yarn_timeline___service_state___store___class=org.apache.hadoop.yarn.server.timeline.recovery.FileSystemTimelineStateStore

# Fall back to the pure-Java memory store to bypass the M1 LevelDB native crash
export YARN_CONF_yarn_timeline___service_store___class=org.apache.hadoop.yarn.server.timeline.MemoryTimelineStore

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR historyserver