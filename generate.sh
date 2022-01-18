#!/usr/bin/env bash

if ! command -v kompose &> /dev/null
then
    curl -L https://github.com/kubernetes/kompose/releases/download/v1.26.1/kompose-linux-amd64 -o kompose
    chmod +x kompose
    sudo mv ./kompose /usr/local/bin/kompose
fi
function komposeConvert() {
	kompose convert -c -f $1.yaml
}

cd compose
komposeConvert seedbox
komposeConvert octoprint
