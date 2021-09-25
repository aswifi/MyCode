FROM debian:10-slim
MAINTAINER libsgh
ENV TZ=Asia/Shanghai
RUN apt-get update
RUN apt-get install -y curl
WORKDIR /app
COPY getApp.sh /app
RUN chmod +x /app/getApp.sh
RUN sh /app/getApp.sh
CMD ["/app/gonelist_linux_amd64/gonelist_linux_amd64"]
