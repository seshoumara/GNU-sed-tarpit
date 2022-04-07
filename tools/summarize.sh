#!/bin/bash

#Author: seshoumara
#http://codegolf.stackexchange.com/users/59010/seshoumara



set -e

sed_src="$1"

sed -n 'p;=' "$sed_src" \
| sed -rn '/^:/{N;s:^(.*)\n(.*)$:\2\t\1:p}' \
| sed -r 's:^:   :;s:^ *([0-9 ]{4,}\t):\1:' \
| sed '1s:^:Line\tSection\n:'
