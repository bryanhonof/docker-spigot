#!/bin/sh

java -Dcom.mojang.eula.agree=$SPIGOT_ACCEPT_EULA \
     -Xms$START_XMS                              \
     -Xmx$START_XMX                              \
     -XX:+UseConcMarkSweepGC                     \
     -jar spigot.jar

