#===================
# Global ARG
#===================
ARG NGINX_VERSION="1.19"
ARG LABEL="Hiroki <hasegawafeedshop@gmail.com>"

#===================
# Build Stage
#===================
# ミドルウェアベンダーのベースイメージを使用
FROM nginx:${NGINX_VERSION} as build

RUN apt-get update -y \
  && apt-get install -y \
     curl \
     vim \
  # キャッシュ削除
  && apt-get clean

#===================
# Develop Stage
#===================
# ベースステージを使用
FROM build as develop
LABEL mantainer=${LABEL}

COPY ./infra/docker/www/develop.nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

#===================
# Production Stage
#===================
# ベースステージを使用
FROM build as production
LABEL mantainer=${LABEL}

COPY ./infra/docker/www/production.nginx.conf /etc/nginx/nginx.conf

# CircleCIコンテナのワークスペースに保存したデプロイソースをコピー
COPY ./workspace/app/build /var/www/app/build

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]