# ベースイメージのインストール
ARG CENTOS_VERSION="8"
FROM centos:${CENTOS_VERSION}
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

RUN dnf upgrade -y \
  # nginxインストール
  && dnf install -y \
      nginx \
      vim \
      langpacks-ja

COPY ./infra/docker/www/nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]