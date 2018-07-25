# Dockerize https://github.com/duo-labs/cloudmapper
# Author: https://github.com/sebastientaggart/
#
# Cloudmapper, from https://github.com/duo-labs/cloudmapper/ is a tool to
# visualize AWS infrastructure.
#
# This project pulls Cloudmapper and initializes it in a docker container. 

FROM python:alpine

LABEL maintainer="https://github.com/sebastientaggart"

EXPOSE 8000
WORKDIR /opt/cloudmapper

RUN apk --no-cache --virtual build-dependencies add \
autoconf \
automake \
libtool \
python-dev \
jq \
g++ \
make \
freetype-dev \
libpng-dev \
git

RUN git clone https://github.com/duo-labs/cloudmapper.git .
RUN pip install pipenv && pipenv --two && pipenv install
RUN pip install --upgrade awscli
#RUN chmod +x entrypoint.sh && touch config.json

VOLUME /opt/cloudmapper/web /opt/cloudmapper/account-data

COPY entrypoint.sh ./entrypoint.sh

COPY .env ./.env

# Keep the container alive for testing
#CMD tail -f /dev/null

CMD ["sh","entrypoint.sh"]
