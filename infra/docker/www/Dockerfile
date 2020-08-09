# ベースイメージのインストール
ARG OS_VERSION="8"
FROM centos:${OS_VERSION}
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

RUN dnf upgrade -y \
  # nginxインストール
  && dnf install -y \
      epel-release \
      nginx \
      langpacks-ja \
      vim

COPY ./infra/docker/www/nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]