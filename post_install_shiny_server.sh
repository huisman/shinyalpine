# Place a shortcut to the shiny-server executable in /usr/bin
ln -s /usr/local/shiny-server/bin/shiny-server /usr/bin/shiny-server

# Create shiny user. On some systems, you may need to specify the full path to 'useradd'
# On alpine use adduser
adduser -S shiny

# Create log, config, and application directories
mkdir -p /var/log/shiny-server
mkdir -p /srv/shiny-server
mkdir -p /var/lib/shiny-server
chown shiny /var/log/shiny-server
mkdir -p /etc/shiny-server
