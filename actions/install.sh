#!/bin/bash

scriptPath=$(realpath $0)
actionsPath=$(dirname $scriptPath)
providerServerPath=$(dirname $actionsPath)

file=~/Library/LaunchAgents/com.pcx.providerserver.daemon.plist
if [ -f "$file" ]; then
    launchctl unload $file
fi
rm -rf /Users/Shared/PCX/Provider/ProviderServer/
mkdir -p /Users/Shared/PCX/Provider/ProviderServer/
cp -a $providerServerPath/. /Users/Shared/PCX/Provider/ProviderServer/
mv /Users/Shared/PCX/Provider/ProviderServer/com.pcx.providerserver.daemon.plist ~/Library/LaunchAgents/com.pcx.providerserver.daemon.plist
launchctl load ~/Library/LaunchAgents/com.pcx.providerserver.daemon.plist
