#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

## Modificado	: Kairo Vox
## Github	: @kairovox

dir="~/.config/rofi"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/powermenu.rasi"

# Options
shutdown=" Desligar"
reboot="⭘ Reiniciar"
lock=" Bloqueio"
suspend="鈴 Hibernar"
logout=" Sair"

# Confirmation
confirm_exit() {
	rofi -dmenu\
		-i\
		-no-fixed-num-lines\
		-p "Tem certeza? : "\
		-theme $dir/confirm.rasi
}

# Message
msg() {
	rofi -theme "$dir/message.rasi" -e "Opções disponíveis  -  sim / s / nao / n"
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Atividade: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == "sim" || $ans == "SIM" || $ans == "s" || $ans == "S" ]]; then
			systemctl poweroff
		elif [[ $ans == "nao" || $ans == "NAO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == "sim" || $ans == "SIM" || $ans == "s" || $ans == "S" ]]; then
			systemctl reboot
		elif [[ $ans == "nao" || $ans == "NAO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $lock)
		if [[ -f /usr/bin/betterlockscreen ]]; then
			betterlockscreen -l
		fi
        ;;
    $suspend)
		ans=$(confirm_exit &)
		if [[ $ans == "sim" || $ans == "SIM" || $ans == "s" || $ans == "S" ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $ans == "nao" || $ans == "NAO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $logout)
	    ans=$(confirm_exit &)
		if [[ $ans == "sim" || $ans == "SIM" || $ans == "s" || $ans == "S" ]]; then
			bspc quit
		elif [[ $ans == "nao" || $ans == "NAO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
	;;
esac
