# ベースイメージのインストール
ARG OS_VERSION="8"
FROM centos:${OS_VERSION}
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

RUN dnf upgrade -y \
  # nginxインストール
  && dnf install -y \
      nginx \
      langpacks-ja \
      vim

# CircleCIコンテナのワークスペースに保存したデプロイソースをコピー
COPY ./workspace/app/build /var/www/app/build

COPY ./infra/docker/www/production.nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]