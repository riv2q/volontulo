FROM ubuntu:16.04

ENV LANG C.UTF-8

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ xenial main restricted" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get build-dep -y python-imaging
RUN apt-get install -y python3-pip \
                       libjpeg8 \
                       libjpeg62-dev \
                       libfreetype6 \
                       libfreetype6-dev \
                       libpq-dev \
                       wget

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 7.4.0

RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash && \
    source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

RUN wget -qO /usr/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod a+x /usr/bin/wait-for-it

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

ADD backend /backend
WORKDIR /backend

RUN pip3 install --upgrade pip
RUN pip3 install -r requirements/dev.txt

RUN cp etc/local_config.yaml.sample local_config.yaml
RUN sed '/^secret_key/ d' local_config.yaml > tmp.yaml && mv tmp.yaml local_config.yaml

ENV SECRET_KEY=a63eb5ef-3b25-4595-846a-5d97d99486f0

RUN echo "secret_key: $SECRET_KEY" >> local_config.yaml

WORKDIR /backend/apps/volontulo

RUN npm install
RUN node node_modules/.bin/gulp build

ADD frontend /frontend
WORKDIR /frontend

RUN npm install -g @angular/cli
RUN npm install


EXPOSE 8000
EXPOSE 4200
