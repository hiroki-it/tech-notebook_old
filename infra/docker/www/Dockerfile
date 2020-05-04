# ベースイメージのインストール
ARG OS_VERSION="8"
FROM centos:${OS_VERSION}
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

COPY /infra/docker/www/package*.json /

RUN dnf update -y \
  && dnf install -y \
      # Sphinx-js要件
      epel-release \
      nodejs \
      npm \
  && npm install

CMD [ "node", "server.js" ]