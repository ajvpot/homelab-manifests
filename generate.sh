#!/usr/bin/env bash

if ! command -v kompose &> /dev/null
then
    curl -L https://github.com/kubernetes/kompose/releases/download/v1.26.1/kompose-linux-amd64 -o kompose
    chmod +x kompose
    sudo mv ./kompose /usr/local/bin/kompose
fi

pushd seedbox
kompose convert -c --volumes hostPath
popd
