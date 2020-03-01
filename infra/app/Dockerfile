# ベースイメージのバージョン
ARG version="6.0"

# ベースとなるDockerイメージ
FROM readthedocs/build:${version}

# Dockrfileの作成者情報
LABEL maintainer="Hiroki <hasegawafeedshop@gmail.com>"

# Dockerfileではデフォルトでroot権限になるので，sudoは不要
RUN pip install\
     # テーマをインストール
     sphinx_rtd_theme\
     # 拡張機能をインストール
     recommonmark\
     sphinx_markdown_tables

# ディレクトリの設定
ENV CURRENT_DIR="var/www/sphinx-app"

# ログイン後のディレクトリ
WORKDIR ${CURRENT_DIR}

# ポート番号
EXPOSE 8000

