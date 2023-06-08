#!/usr/bin/env bash

NOTIFY_ICON_LOW=/usr/share/icons/Papirus/32x32/apps/pacman.svg
NOTIFY_ICON_NORMAL=/usr/share/icons/Papirus/32x32/apps/pamac-updater.svg
NOTIFY_ICON_CRITICAL=/usr/share/icons/Papirus/32x32/apps/distributor-logo-archlinux.svg

get_total_updates() { UPDATES=$(checkupdates 2>/dev/null | wc -l); }

while true; do
    get_total_updates

    # notify user of updates
    if hash notify-send &>/dev/null; then
        if (( UPDATES > 50 )); then
            notify-send -u critical -i $NOTIFY_ICON_CRITICAL \
                "Voce realmente precisa atualizar" "$UPDATES Novos pacotes"
        elif (( UPDATES > 25 )); then
            notify-send -u normal -i $NOTIFY_ICON_NORMAL \
                "Voce deve atualizar logo" "$UPDATES Novos pacotes"
        elif (( UPDATES > 2 )); then
            notify-send -u low -i $NOTIFY_ICON_LOW \
                "$UPDATES Novos pacotes"
        fi
    fi

    # when there are updates available
    # every 10 seconds another check for updates is done
    while (( UPDATES > 0 )); do
        if (( UPDATES == 1 )); then
            echo " $UPDATES"
        elif (( UPDATES > 1 )); then
            echo " $UPDATES"
        else
            echo " Nenhum"
        fi
        sleep 10
        get_total_updates
    done

    # when no updates are available, use a longer loop, this saves on CPU
    # and network uptime, only checking once every 30 min for new updates
    while (( UPDATES == 0 )); do
        echo " Nenhum"
        sleep 1800
        get_total_updates
    done
done
