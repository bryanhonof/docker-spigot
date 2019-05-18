# ---------------------------------------------------------------------------- #
# Minecraft Spigot server
#
# VERSION                 1.14.1
# ---------------------------------------------------------------------------- #
ARG JAVA_VERSION=12

FROM bryanhonof/buildtools AS buildtools
# ---------------------------------------------------------------------------- #
FROM openjdk:$JAVA_VERSION-alpine

# Container information
LABEL maintainer         = "Bryan Honof"                                 \
      maintainer.email   = "bryan@bryanhonof.be"                         \
      maintainer.website = "https://www.bryanhonof.be"                   \
      version            = "1.14.1"                                      \
      description        = "A minecraft spigot server in a container!"   \
      dockerfile.repo    = "https://github.com/bryanhonof/docker_spigot"

# Environment variables.
ENV MOJANG_EULA_AGREE false
ENV START_XMS         1G
ENV START_XMX         1G
ENV SPIGOT_DIR        /opt/spigot
ENV DATA_DIR          /srv/minecraft
ENV BIN_DIR           /usr/local/bin
ENV EXPOSE_PORT       25565
ENV RUN_USER          spigot
ENV RUN_GROUP         spigot

# Create a minecraft user and group that will execute the server so the
# process is not running as root.
RUN    addgroup -g 1000 -S $RUN_GROUP                            \
    && adduser  -H -s /bin/sh -G $RUN_GROUP -u 1000 -S $RUN_USER

# Copy over files from the buildtools container.
COPY --chown=1000:1000 --from=buildtools /tmp/build/spigot-*.jar $SPIGOT_DIR/spigot.jar

# Copy over the setup scripts from the host machine.
COPY --chown=1000:1000 ./scripts/start.sh $BIN_DIR/start
COPY --chown=1000:1000 ./scripts/eula.sh  $BIN_DIR/eula

RUN    mkdir    -p $DATA_DIR                                   \
    && chown    -Rv $RUN_USER:$RUN_GROUP $SPIGOT_DIR $DATA_DIR

# Switch to the minecraft user.
USER $RUN_USER:$RUN_GROUP

# The directory where the spigot.jar has to be run.
WORKDIR $SPIGOT_DIR

# Make the server directory persistant so world data is preserverd.
VOLUME ["$SPIGOT_DIR"]
VOLUME ["$DATA_DIR"]

# Expose the defalt minecraft port.
EXPOSE $EXPOSE_PORT

# Gracefull exit.
STOPSIGNAL SIGTERM

# Start the server.
ENTRYPOINT ["start"]

# Placeholder.
CMD [""]

