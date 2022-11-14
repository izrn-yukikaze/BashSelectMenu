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

Choices=("雪風" "綾波" "時雨" "夕立" "江風")
CurrentChoice=0
Key=""

ShowMenu(){
    for i in "${!Choices[@]}"; do
        if [[ "$i" = "$CurrentChoice" ]]; then
            echo " * $i: ${Choices[$i]}"
        else
            echo "   $i: ${Choices[$i]}"
        fi
    done
}

UpdateMenuScreen(){
    ClearUpperLines "${#Choices[@]}"
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
        Enter)
            break
            ;;
    esac
    Key=""
done 

echo "選択されたのは${Choices[$CurrentChoice]}です"

