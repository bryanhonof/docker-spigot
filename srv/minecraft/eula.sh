#!/bin/sh

check_eula()
{
    if [ true != "$SPIGOT_ACCEPT_EULA" ]; then
        echo "[WARNING] EULA not accepted."
        echo "To accept the EULA either set the SPIGOT_ACCEPT_EULA environment variable to true in the container or,"
        echo "set the eula manually from within the compiler at /srv/minecraft/eula.txt."
        echo "EULA (https://account.mojang.com/documents/minecraft_eula)"
        echo "$(date)"
    fi
}

set_eula()
{
    if [ -f "./eula.txt" ]; then
        rm eula.txt
    fi

    touch eula.txt
    echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." >> eula.txt
    echo "#$(date)" >> eula.txt
    echo "eula=$SPIGOT_ACCEPT_EULA" >> eula.txt
}

