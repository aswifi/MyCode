#!/bin/bash
version=$INDEX_VERSION
echo $INDEX_VERSION
version="v0.5.3"
if [ "$version" = "" ]
then
    version=`curl --silent "https://api.github.com/repos/cugxuan/gonelist/releases/latest" \
        | grep '"tag_name":' \
        | sed -E 's/.*"([^"]+)".*/\1/'`
fi
curl -sOL "https://github.com/cugxuan/gonelist/releases/download/{$version}/gonelist_linux_amd64.tar.gz"
sha256sum "gonelist_linux_amd64.tar.gz"
#gzip -d cloud-torrent_linux_amd64.gz
tar -zxf gonelist_linux_amd64.tar.gz && cd gonelist_linux_amd64
chmod +x cloud-torrent_linux_amd64
