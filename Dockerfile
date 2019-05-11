# Dockerize https://github.com/duo-labs/cloudmapper
# Author: https://github.com/sebastientaggart/
#
# Cloudmapper, from https://github.com/duo-labs/cloudmapper/ is a tool to
# visualize AWS infrastructure.
#
# This project pulls Cloudmapper and initializes it in a docker container.

FROM python:3.7-alpine

LABEL maintainer="https://github.com/sebastientaggart"

EXPOSE 8000
WORKDIR /opt/cloudmapper

# By default python buffers output, which prevents output to docker logs.  This
# disables the output buffering so logging works as expected.
ENV PYTHONUNBUFFERED=0

RUN apk --no-cache --virtual build-dependencies add \
autoconf \
automake \
libtool \
python-dev \
jq \
g++ \
make \
openblas \
openblas-dev \
freetype-dev \
libpng-dev \
git

RUN git clone https://github.com/duo-labs/cloudmapper.git .
RUN git checkout -b 2.5.5 refs/tags/2.5.5
RUN pip install pipenv && pipenv install --skip-lock
RUN pip install --upgrade awscli

COPY prepare.sh ./prepare.sh
