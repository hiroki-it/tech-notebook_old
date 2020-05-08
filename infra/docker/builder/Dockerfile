# ベースイメージのインストール
ARG OS_VERSION="8"
FROM centos:${OS_VERSION}
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

RUN dnf update -y \
  && dnf install -y \
      # システム全体要件
      curl \
      git \
      langpacks-ja \
      make \
      unzip \
      vim \
      # Pyenv要件
      bzip2 \
      bzip2-devel \
      gcc \
      gcc-c++ \
      libffi-devel \
      openssl-devel \
      readline-devel \
      sqlite-devel \
      zlib-devel

# Pyenvインストール
RUN git clone https://github.com/pyenv/pyenv.git /.pyenv
# 環境変数PATHの設定
ENV PYENV_ROOT /.pyenv
ENV PATH ${PATH}:/${PYENV_ROOT}/bin

# バージョン
ENV PYTHON_VERSION_27 "2.7.16"
ENV PYTHON_VERSION_38 "3.8.0"
# Python
RUN pyenv install ${PYTHON_VERSION_27} \
  && pyenv install ${PYTHON_VERSION_38} \
  # バージョン切り替え
  && pyenv global ${PYTHON_VERSION_38} \
  && dnf install -y \
      # EPELリポジトリ
      epel-release \
      # PIP
      python3-pip \
  && pip3 install \
      # NOTE: sphinx-buildが認識されない問題への対処
      sphinx --upgrade --ignore-installed six \
      # テーマ
      sphinx_rtd_theme \
      # 拡張機能
      sphinx-autobuild \
      recommonmark \
      sphinx_markdown_tables \
      sphinxcontrib-sqltable

CMD ["/bin/bash"]