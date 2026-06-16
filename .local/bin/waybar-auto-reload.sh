#!/bin/dash
while inotifywait -e close_write ~/.config/waybar; do pkill -x -SIGUSR2 waybar; done
