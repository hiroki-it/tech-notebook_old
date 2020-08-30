#===================
# Global ARG
#===================
ARG PYTHON_VERSION="3.8.5"

#===================
# Build Stage
#===================
FROM python:${PYTHON_VERSION} as build
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

RUN apt-get update -y \
  && apt-get install -y \
      # システム全体要件
      git \
      make \
#---------
# Sphinx
#---------
  && pip3 install --upgrade --ignore-installed six \
      # sphinx-buildが認識されない問題への対処
      sphinx \
      # テーマ
      sphinx_rtd_theme \
      # 拡張機能
      recommonmark \
      sphinxcontrib-sqltable \
      sphinx_markdown_tables \
  # キャッシュ削除
  && apt-get clean

#===================
# Develop Stage
#===================
FROM build as develop

CMD ["/bin/bash"]

#===================
# Production Stage
#===================
FROM build as production

CMD ["/bin/bash"]