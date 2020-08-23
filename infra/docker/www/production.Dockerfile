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

# CircleCIコンテナのワークスペースに保存したデプロイソースをコピー
COPY ./workspace/app/build /var/www/app/build

COPY ./infra/docker/www/production.nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]