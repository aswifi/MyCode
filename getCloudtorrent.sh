#!/bin/bash
version=$PAN_INDEX_VERSION
echo $PAN_INDEX_VERSION
version="1.3.8"
if [ "$version" = "" ]
then
    version=`curl --silent "https://api.github.com/repos/boypt/simple-torrent/releases/latest" \
        | grep '"tag_name":' \
        | sed -E 's/.*"([^"]+)".*/\1/'`
fi
curl -sOL "https://github.com/boypt/simple-torrent/releases/download/${version}/cloud-torrent_linux_amd64.gz
sha256sum "cloud-torrent_linux_amd64.gz"
tar -zxf cloud-torrent_linux_amd64.gz && cd cloud-torrent_linux_amd64
chmod +x cloud-torrent_linux_amd64