#!/bin/bash

currentPath=$(pwd)
scriptPath=$(realpath $0)
providerServerPath=$(dirname $scriptPath)

echo "Entering ProviderServer path"
cd $providerServerPath

echo "Adding SSH Key"
ssh-add -K ~/.ssh/id_rsa

echo "Build & Run ProviderServer"
vapor clean -y
vapor build && vapor run --port=8888

# echo "Setup nginx proxy"
# sudo cp $providerServerPath/nginx/nginx.conf /etc/nginx/nginx.conf
# sudo systemctl restart nginx

# echo "Setup PostgreSQL"


# nohup vapor run --port=8888 &>/dev/null &

# echo "Return to initial path"
# cd $currentPath

# echo "Set Keeper's State to everythingIsOk"
# echo "state=everythingIsOk" > $pcxPath/keeper/variables/state
#### moved to providerrunner ###
