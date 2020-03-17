#!/bin/bash

currentPath=$(pwd)
scriptPath=$(realpath $0)
actionsPath=$(dirname $scriptPath)
providerServerPath=$(dirname $actionsPath)

bash $providerServerPath/providerServer.sh
