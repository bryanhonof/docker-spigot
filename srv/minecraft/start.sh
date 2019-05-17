#!/bin/sh

source eula.sh

check_eula
set_eula

java -Xms$START_XMS -Xmx$START_XMX -XX:+UseConcMarkSweepGC -jar spigot.jar

