#!/bin/bash

pane_tty=$1

echo "pane_tty => '$pane_tty'"
ps -o state= -o comm= -t "${pane_tty}" \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'
