#!/bin/sh

. /tmp/build/devel/setup.sh
export ROS_MASTER_URI="http://${MASTER:-localhost}:11311"
ipfs daemon --init true --migrate true --enable-gc &
exec roslaunch drone_recorder_gopro recorder.launch 
