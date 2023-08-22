# Clone the repository from GitHub
git clone https://github.com/rstudio/shiny-server.git

# Get into a temporary directory in which we'll build the project
cd shiny-server
mkdir tmp
cd tmp

# Install our private copy of Node.js
sh ../external/node/install-node.sh

# Add the bin directory to the path so we can reference node
DIR=`pwd`
PATH=$DIR/../bin:$PATH

# Patch shinyserver to work with busybox su
sed -i 's/--login"]/-l"]/' ../lib/worker/app-worker.js
sed -i 's/--login"]/-l"]/' ../lib/worker/app-worker.ts

# Use cmake to prepare the make step. Modify the "--DCMAKE_INSTALL_PREFIX"
# if you wish the install the software at a different location.
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ../

# Compile native code and install npm dependencies
make
mkdir ../build
# Fix missing node-gyp
sh ../bin/npm install node-gyp
(cd .. && sh ./bin/npm install)

# Install the software at the predefined location
make install

# Install default config file
mkdir -p /etc/shiny-server
cp ../config/default.config /etc/shiny-server/shiny-server.conf
