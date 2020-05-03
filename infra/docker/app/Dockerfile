# ベースイメージのインストール
ARG OS_VERSION="8"
FROM centos:${OS_VERSION}
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

# 必須パッケージ
RUN dnf update -y \
  && dnf install -y \
      curl \
      git \
      langpacks-ja \
      make \
      unzip \
      vim

# Pyenvに必要なパッケージ
RUN dnf install -y \
     bzip2 \
     bzip2-devel \
     gcc \
     gcc-c++ \
     libffi-devel \
     openssl-devel \
     readline-devel \
     sqlite-devel \
     zlib-devel

# Pyenvのインストール，環境変数PATHの設定
RUN git clone https://github.com/pyenv/pyenv.git /.pyenv
ENV PYENV_ROOT "/.pyenv"
ENV PATH "${PATH}:/${PYENV_ROOT}/bin"

# Pythonのインストールとバージョン切り替え
ARG PYTHON_VERSION_27="2.7.16"
ARG PYTHON_VERSION_38="3.8.0"
RUN pyenv install ${PYTHON_VERSION_27} \
  && pyenv install ${PYTHON_VERSION_38} \
  && pyenv global ${PYTHON_VERSION_38}

# PIPのインストール
RUN dnf install -y \
     epel-release \
     python3-pip

# Dockerfileではデフォルトでroot権限になるので，sudoは不要
RUN pip3 install --user\
     sphinx \
     sphinx-autobuild \
     # テーマをインストール
     sphinx_rtd_theme \
     # 拡張機能をインストール
     recommonmark \
     sphinx_markdown_tables \
     sphinxcontrib-sqltable

# ssh接続後ディレクトリの設定
WORKDIR "/var/www/sphinx"

CMD ["/bin/bash"]