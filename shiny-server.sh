#!/bin/sh

# Ensure directory for app logs exists with correct permissions
chown shiny /var/log/shiny-server

env > /home/shiny/.Renviron
chown shiny /home/shiny/.Renviron

# start shiny server
exec /usr/bin/shiny-server 2>&1
