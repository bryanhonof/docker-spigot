#!/bin/sh

# Check eula
source check-eula

if check_eula; then
    set_eula

    # Start the server
    java -Xms$JAVA_INITIAL_HEAP_SIZE \
        -Xmx$JAVA_MAX_HEAP_SIZE \
        -XX:+UseG1GC \
        -XX:+UnlockExperimentalVMOptions \
        -XX:MaxGCPauseMillis=100 \
        -XX:+DisableExplicitGC \
        -XX:TargetSurvivorRatio=90 \
        -XX:G1NewSizePercent=50 \
        -XX:G1MaxNewSizePercent=80 \
        -XX:G1MixedGCLiveThresholdPercent=35 \
        -XX:+AlwaysPreTouch \
        -XX:+ParallelRefProcEnabled \
        -XX:+UseLargePagesInMetaspace \
        -Dusing.aikars.flags=mcflags.emc.gs \
        -jar $SRV_DIR/spigot.jar \
        --port $EXPOSE_PORT \
        --config $SRV_DIR/server.properties \
        --world-dir $SRV_DIR/worlds \
        --spigot-settings $SRV_DIR/spigot.yml \
        --plugins $SRV_DIR/plugins \
        --commands-settings $SRV_DIR/commands.yml \
        --bukkit-settings $SRV_DIR/bukkit.yml
fi

exit 0
