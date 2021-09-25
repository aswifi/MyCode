FROM debian:10-slim
MAINTAINER libsgh
ENV TZ=Asia/Shanghai
RUN apt-get update
RUN apt-get install -y curl
WORKDIR /app
COPY getCloudtorrent.sh /app
RUN chmod +x /app/getCloudtorrent.sh
RUN sh /app/getCloudtorrent.sh
CMD ["/app/cloud-torrent_linux_amd64"]
