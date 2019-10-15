FROM ubuntu:bionic
COPY ci/dockerhub/linux-install.sh ./
RUN ./linux-install.sh
