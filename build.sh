#!/bin/bash

set -e

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running P2Park   #
#################################################################
sudo apt-get update
#################################################################
# Build P2Park from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building P2Park           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/p2park
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/P2PK/p2park/.git
fi

cd /usr/local/p2park/src
file=/usr/local/p2park/src/p2parkd
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/p2park/src/p2parkd /usr/bin/p2parkd

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.p2park
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.p2park
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.p2park/p2park.conf
file=/etc/init.d/p2park
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo p2parkd' | sudo tee /etc/init.d/p2park
        sudo chmod +x /etc/init.d/p2park
        sudo update-rc.d p2park defaults
fi

/usr/bin/p2parkd
echo "P2Park has been setup successfully and is running..."
exit 0

