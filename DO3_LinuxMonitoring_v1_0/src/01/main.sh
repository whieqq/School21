#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Параметр не введен" >&2
  exit 1
elif [ $# -gt 1 ]; then
  echo "Введено недопустимое число параметров" >&2
  exit 2
elif [[ "$1" =~ ^[-+]?[0-9]+([.][0-9]+)?$ ]]; then
  echo "Ошибка! Вы ввели число!" >&2
  exit 3
else
  printf '%s\n' "$1"
fi