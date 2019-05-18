#!/bin/sh

source eula

check_eula
set_eula

java -Xms$START_XMS                                  \
     -Xmx$START_XMX                                  \
     -XX:+UseConcMarkSweepGC                         \
     -jar                $SPIGOT_DIR/spigot.jar      \
     --port              $EXPOSE_PORT                \
     --config            $DATA_DIR/server.properties \
     --world-dir         $DATA_DIR/worlds            \
     --spigot-settings   $DATA_DIR/spigot.yml        \
     --plugins           $DATA_DIR/plugins           \
     --commands-settings $DATA_DIR/commands.yml      \
     --bukkit-settings   $DATA_DIR/bukkit.yml

