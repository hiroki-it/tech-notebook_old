#============================
# Base Stage
#============================
ARG CENTOS_VERSION="8"
FROM centos:${CENTOS_VERSION} as base
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

RUN dnf upgrade -y \
  && dnf install -y \
      # Pyenv要件
      git \
      make \
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

# Pyenvインストール
RUN git clone https://github.com/pyenv/pyenv.git /.pyenv
# 環境変数PATHの設定
ENV PYENV_ROOT /.pyenv
ENV PATH ${PATH}:/${PYENV_ROOT}/bin
ENV PYTHON_VERSION_38 "3.8.0"

# Pythonインストール
RUN pyenv install ${PYTHON_VERSION_38} \
  # Pythonバージョン切り替え
  && pyenv global ${PYTHON_VERSION_38}

#============================
# Production Stage
#============================
ARG CENTOS_VERSION="8"
FROM centos:${CENTOS_VERSION}

ENV PYTHON_VERSION_38 "3.8.0"
COPY --from=base /.pyenv/versions/${PYTHON_VERSION_38}/bin/python /.pyenv/versions/${PYTHON_VERSION_38}/bin/python

RUN dnf upgrade -y \
  && dnf install -y \
      # システム全体要件
      curl \
      langpacks-ja \
      make \
      vim \
  && dnf install -y \
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
      sphinxcontrib-sqltable \
      sphinx_fontawesome \
  # メタデータ削除
  && dnf clean all \
  # キャッシュ削除
  && rm -rf /var/cache/dnf
  
CMD ["/bin/bash"]