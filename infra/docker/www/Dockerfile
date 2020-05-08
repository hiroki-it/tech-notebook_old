# ベースイメージのインストール
ARG OS_VERSION="8"
FROM centos:${OS_VERSION}
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

RUN dnf update -y \
  # nginxインストール
  && dnf install -y \
      nginx \
      epel-release \
      vim

COPY infra/docker/www/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]