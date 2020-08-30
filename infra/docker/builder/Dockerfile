#===================
# Global ARG
#===================
ARG PYTHON_VERSION="3.8.5"
ARG LABEL="Hiroki <hasegawafeedshop@gmail.com>"

#===================
# Build Stage
#===================
FROM python:${PYTHON_VERSION}-slim as build

#---------
# Sphinx
#---------
# sphinx-buildが挙動しなくなる問題のため，sixを無視
RUN pip3 install --upgrade --ignore-installed six \
     sphinx \
     # テーマ
     sphinx_rtd_theme \
     # 拡張機能
     recommonmark \
     sphinxcontrib-sqltable \
     sphinx_markdown_tables
     
#===================
# Base Stage
#===================
FROM python:${PYTHON_VERSION}-slim as base

RUN apt-get update -y \
  && apt-get install -y \
      git \
      make \
  # キャッシュ削除
  && apt-get clean

# Build Stageから必要なバイナリファイルをコピー
COPY --from=build /usr/local /usr/local

#===================
# Develop Stage
#===================
FROM base as develop
LABEL mantainer=${LABEL}

CMD ["/bin/bash"]

#===================
# Production Stage
#===================
FROM base as production
LABEL mantainer=${LABEL}

CMD ["/bin/bash"]