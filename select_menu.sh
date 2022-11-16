#!/usr/bin/env bash

source ./capture_special_keys.sh

ClearScreen(){
    printf "\033[2J"
}
ClearRight(){
    printf "\033[0K"
}
ClearLeft(){
    printf "\033[1K"
}
ClearLine(){
    printf "\033[2K"
}
MoveCursor(){
    printf "\033[%d;%dH" "$1" "$2"
}
MoveCursorUp(){
    printf "\033[%dA" "$1"
}
MoveCursorDown(){
    printf "\033[%dB" "$1"
}
MoveCursorRight(){
    printf "\033[%dC" "$1"
}
MoveCursorLeft(){
    printf "\033[%dD" "$1"
}
SaveCursor(){
    printf "\033[s"
}
ResetStyle(){
    printf "\033[0m"
}
ClearUpperLines(){
    # shellcheck disable=SC2034
    for i in $(seq 1 "$1"); do
        MoveCursorUp 1
        ClearLine
    done
}

# ------- From Here ------- #

Choices=("雪風" "綾波" "時雨" "夕立" "江風" "川内" "神通" "那珂" "阿賀野" "能代" "矢矧" "酒匂")
CurrentChoice=0
Key=""
Ncol=4
Nrow=3

ShowMenu(){
  for i in `seq 0 $((Nrow - 1))`; do
	for j in `seq 0 $((Ncol - 1))`; do
	  N=$((i + j * Nrow))
	  if [[ $N -ge ${#Choices[@]} ]]; then
	    break
	  fi
	  if [[ "$N" = "$CurrentChoice" ]]; then
	    printf "\033[48;2;0;255;255;38;2;0;0;255m o %2d: %s\033[0m\t" "$N" "${Choices[$N]}"
	    else
		printf "\033[38;2;0;255;255m - %2d: %s\033[0m\t" "$N" "${Choices[$N]}"
	    fi
	done
	printf "\n"
    done
}

UpdateMenuScreen(){
    ClearUpperLines "$Nrow"
    ShowMenu
}

ShowMenu

while [[ -z "$Key" ]]; do
    Key="$(capture_keys)"
    case "$Key" in
        Up)
            if (( "$CurrentChoice" != 0 )); then
                CurrentChoice=$((CurrentChoice - 1))
                UpdateMenuScreen
            fi
            ;;
        Down)
            if (( "$CurrentChoice" != "${#Choices[@]}" - 1 )); then
                CurrentChoice=$((CurrentChoice + 1))
                UpdateMenuScreen
            fi
            ;;
	Right)
	  if [[ $((CurrentChoice + Nrow)) -lt ${#Choices[@]} ]]; then
	    CurrentChoice=$((CurrentChoice + Nrow))
	    UpdateMenuScreen
	  fi
	  ;;
	Left)
	  if [[ $((CurrentChoice - Nrow)) -ge 0 ]]; then
	    CurrentChoice=$((CurrentChoice - Nrow))
	    UpdateMenuScreen
	  fi
	  ;;
	Tab)
	  CurrentChoice=$(((CurrentChoice + 1) % ${#Choices[@]}))
	  UpdateMenuScreen
	  ;;
	ShiftTab)
	  CurrentChoice=$(((CurrentChoice - 1 + ${#Choices[@]}) % ${#Choices[@]}))
	  UpdateMenuScreen
	  ;;
        Enter)
            break
            ;;
    esac
    Key=""
done 

echo -e "選択されたのは\033[38;2;0;0;255m${Choices[$CurrentChoice]}\033[0mです"

