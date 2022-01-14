#!/usr/bin/env bash
pushd seedbox
kompose convert -c --volumes hostPath
popd
