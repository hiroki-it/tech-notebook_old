# ベースイメージのバージョン．
ARG version="6.0"

# ベースとなるDockerイメージ．
FROM readthedocs/build:${version}

# Dockrfileの作成者情報
LABEL maintainer="Hiroki <hasegawafeedshop@gmail.com>"

# ベースイメージ内で，
# Pythonのバージョンは一通りインストールされているので，
# pyenvで切り替える
RUN pyenv global 3.8.0

# Dockerfileではデフォルトでroot権限になるので，sudoは不要
RUN pip install \
    sphinx \
    # pipのアップグレード
    --upgrade pip \
    # テーマをインストール
    sphinx_rtd_theme \
    # 拡張機能をインストール
    recommonmark \
    sphinx_markdown_tables \
    sphinxcontrib-sqltable

# ディレクトリの設定
ENV CURRENT_DIR="var/www/sphinx"

# ssh接続後のディレクトリ
WORKDIR ${CURRENT_DIR}

# ポート番号
EXPOSE 8000

