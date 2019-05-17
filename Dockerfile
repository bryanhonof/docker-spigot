# Minecraft Spigot server
#
# VERSION                 1.14.1

# The spigot jar has to be compiled from the BuildTools.
FROM openjdk:12-alpine AS buildtools

# The link to get the BuildTools.jar from.
ENV BUILDTOOLS_URL https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
# Version that has to be compiled.
ENV SPIGOT_REV 1.14.1

# Working directory.
WORKDIR /tmp/build

# Install git and curl to fetch the depencencies.
# Build the spigot.jar file with the BuildTools.
RUN    apk --no-cache update                              \
    && apk --no-cache add --virtual dependencies git curl \
    && curl -o BuildTools.jar $BUILDTOOLS_URL             \
    && java -jar BuildTools.jar --rev $SPIGOT_REV         \
    && apk del dependencies

# ---------------------------------------------------------------------------- #

# The accually spigot server container.
FROM openjdk:12-alpine

LABEL maintainer         = "Bryan Honof"                                 \
      maintainer.email   = "bryan@bryanhonof.be"                         \
      maintainer.website = "https://www.bryanhonof.be"                   \
      version            = "1.14.1"                                      \
      description        = "A minecraft spigot server in a cointainer!"  \
      dockerfile.repo    = "https://github.com/bryanhonof/docker_spigot"

ENV SPIGOT_ACCEPT_EULA false
ENV START_XMS          1G
ENV START_XMX          1G

WORKDIR /srv/minecraft

# Copy over files from the buildtools container.
COPY --from=buildtools /tmp/build/spigot-*.jar      ./spigot.jar
#COPY --from=buildtools /tmp/build/craftbukkit-*.jar ./craftbukkit.jar

# Copy over the setup scripts
COPY ./srv/minecraft/start.sh /srv/minecraft/start.sh
COPY ./srv/minecraft/eula.sh  /srv/minecraft/eula.sh

RUN    addgroup -g 1000 -S minecraft                            \
    && adduser  -H -s /bin/sh -G minecraft -u 1000 -S minecraft \
    && chown    -Rv minecraft:minecraft /srv/minecraft

USER minecraft:minecraft

VOLUME /srv/minecraft

EXPOSE 25565

CMD ["./start.sh"]

