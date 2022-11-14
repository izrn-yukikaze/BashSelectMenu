#!/usr/bin/env bash

capture_keys(){
  local PUSHED_KEY buff
  IFS= read -n1 -s PUSHED_KEY

  case "$PUSHED_KEY" in
    'h')
      echo "Left"
      ;;
    'j' | $'\x09')
      echo "Down"
      ;;
    'k')
      echo "Up"
      ;;
    'l')
      echo "Right"
      ;;

    $'\x1b')
      read -r -n2 -s buff
      PUSHED_KEY+="$buff"

      case "$PUSHED_KEY" in
	$'\x1b\x5b\x41' | $'\x1b\x5b\x5a')
	  echo "Up"
	  ;;
	$'\x1b\x5b\x42')
	  echo "Down"
	  ;;
	$'\x1b\x5b\x43')
	  echo "Right"
	  ;;
	$'\x1b\x5b\x44')
	  echo "Left"
	  ;;
      esac
      ;;

    "")
      echo "Enter"
      ;;
    $'\x7f')
      echo "Backspace"
      ;;
    $'\x20')
      echo "Space"
      ;;
  esac
}

