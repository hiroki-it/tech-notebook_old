#=============
# Global ARG
#=============
ARG CENTOS_VERSION="8"
ARG LABEL="Hiroki <hasegawafeedshop@gmail.com>"
ARG PYTHON_VERSION="3.8.0"

#=============
# Base Stage
#=============
FROM centos:${CENTOS_VERSION} as base
LABEL mantainer=${LABEL}

RUN dnf upgrade -y \
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
      zlib-devel \
  # メタデータ削除
  && dnf clean all \
  # キャッシュ削除
  && rm -rf /var/cache/dnf
  
#-------------
# Pyenv
#-------------
RUN git clone https://github.com/pyenv/pyenv.git /.pyenv
# パスを環境変数に設定
ENV PYENV_ROOT /.pyenv
ENV PATH ${PATH}:/${PYENV_ROOT}/bin

#-------------
# Python
#-------------
# バージョンを環境変数に設定
ARG PYTHON_VERSION
ENV PYTHON_VERSION ${PYTHON_VERSION}
# NOTE: Pyenv経由のインストールだとPythonのバイナリファイルを管理しやすい
RUN pyenv install ${PYTHON_VERSION} \
  # バージョン切り替え
  && pyenv global ${PYTHON_VERSION}

#============================
# Production Stage
#============================
FROM centos:${CENTOS_VERSION}
LABEL mantainer=${LABEL}

# 環境変数を設定
ARG PYTHON_VERSION
ENV PYTHON_VERSION ${PYTHON_VERSION}

# BaseStageからPythonを取得
COPY --from=base /.pyenv/versions/${PYTHON_VERSION}/bin/python /.pyenv/versions/${PYTHON_VERSION}/bin/python

RUN dnf upgrade -y \
  && dnf install -y \
      # システム全体要件
      which \
      curl \
      make \
      vim \
      langpacks-ja \
#-------------
# Pip
#-------------
      python3-pip \
#-------------
# Sphinx
#-------------
  && pip3 install \
      # NOTE: sphinx-buildが認識されない問題への対処
      sphinx --upgrade --ignore-installed six \
      # テーマ
      sphinx_rtd_theme \
      # 拡張機能
      sphinx-autobuild \
      recommonmark \
      sphinx_markdown_tables \
      sphinxcontrib-sqltable \
  # メタデータ削除
  && dnf clean all \
  # キャッシュ削除
  && rm -rf /var/cache/dnf
  
CMD ["/bin/bash"]