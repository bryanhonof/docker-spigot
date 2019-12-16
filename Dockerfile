# ---------------------------------------------------------------------------- #
# Minecraft Spigot server
#
# VERSION                 1.15
# ---------------------------------------------------------------------------- #
ARG JAVA_VERSION=8
ARG SPIGOT_REV=1.15

FROM bryanhonof/docker-spigot-buildtools:${SPIGOT_REV} AS buildtools
# ---------------------------------------------------------------------------- #
FROM openjdk:$JAVA_VERSION-alpine

ARG SPIGOT_REV

# Container information
LABEL maintainer         = "Bryan Honof"                                 \
      maintainer.email   = "bryan@bryanhonof.be"                         \
      maintainer.website = "https://www.bryanhonof.be"                   \
      version            = "1.15"                                        \
      description        = "A minecraft spigot server in a container!"   \
      dockerfile.repo    = "https://github.com/bryanhonof/docker_spigot"

# Environment variables.
ENV MOJANG_EULA_AGREE false
ENV JAVA_INITIAL_HEAP_SIZE 1G
ENV JAVA_MAX_HEAP_SIZE 6G
ENV SRV_DIR /srv/minecraft-server
ENV BIN_DIR /usr/local/bin
ENV EXPOSE_PORT 25565
ENV RUN_USER minecraft
ENV RUN_GROUP minecraft
ENV SPIGOT_VERSION $SPIGOT_REV

# Check if the server did not crash
HEALTHCHECK --interval=60s --timeout=30s --start-period=60s --retries=5 \
    CMD nc -z localhost $EXPOSE_PORT

# Create a minecraft user and group that will execute the server so the
# process is not running as root
RUN addgroup -g 1000 -S $RUN_GROUP \
    && adduser -H -s /bin/sh -G $RUN_GROUP -u 1000 -S $RUN_USER

# Copy over files from the buildtools container
COPY --chown=1000:1000 --from=buildtools /tmp/build/spigot-${SPIGOT_VERSION}.jar $SRV_DIR/spigot.jar

# Copy over the setup scripts from the host machine
COPY --chown=1000:1000 ./scripts/start-server.sh $BIN_DIR/start-server
COPY --chown=1000:1000 ./scripts/check-eula.sh $BIN_DIR/check-eula

RUN chmod 550 $BIN_DIR/start-server $BIN_DIR/check-eula

RUN mkdir -p $SRV_DIR \
    && chown -Rv $RUN_USER:$RUN_GROUP $SPIGOT_DIR $SRV_DIR

# Switch to the minecraft user
USER $RUN_USER:$RUN_GROUP

# The directory where the spigot.jar has to be run
WORKDIR $SRV_DIR

# Make the server directory persistant so world data is preserverd
VOLUME ["$SRV_DIR"]

# Expose the defalt minecraft port
EXPOSE $EXPOSE_PORT

# Gracefull exit
STOPSIGNAL SIGTERM

# Start the server
ENTRYPOINT ["start-server"]

# Placeholder
CMD [""]

