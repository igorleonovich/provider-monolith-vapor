#!/bin/bash

file=~/Library/LaunchAgents/com.pcx.providerserver.daemon.plist
if [ -f "$file" ]; then
    launchctl unload $file
    rm $file
fi
rm -rf /Users/Shared/PCX/Provider/ProviderServer/
