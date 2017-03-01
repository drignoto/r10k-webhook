FROM alpine:latest

#labels
ARG PROJECT_NAME="r10k-webhook"
ARG VERSION="0.1.0"
ARG PROJECT_URL="https://github.com/drignoto/r10k-webhook.git"
ARG LBLDESCRIPTION="Docker Image for deploy control-repo by r10k, using Gogs repository and webhooks."
ARG VENDOR="Dr.IgNoTo & EolDavix"
ARG MAINTAINER_MAIL="dr.ignoto@gmail.com"

LABEL org.label-schema.name=${PROJECT_NAME} \
			org.label-schema.description=${LBLDESCRIPTION} \
			org.label-schema.url=${PROJECT_URL} \
			org.label-schema.vcs-url=${PROJECT_URL} \
			org.label-schema.vendor=$VENDOR \
			org.label-schema.version=${VERSION:-latest} \
			org.label-schema.schema-version="1.0" \
			maintainer=${MAINTAINER_MAIL}

#Variables de entorno
ENV PORT=9001 SECRET="Changeme"

#Comandos Dockerfile bajo esta línea
WORKDIR /srv

RUN apk add --update git \
                     ruby \
		     python \
		     ruby-dev \
		     openssh-client \
		     build-base \
		     py2-pip && \
		     gem install r10k --no-rdoc --no-ri && \
		     gem install json --no-rdoc --no-ri && \
		     pip install web.py && \
		     apk del build-base && \
		     rm -rf /var/cache/apk/*

COPY code/* /srv/

RUN mkdir /root/.ssh/ && \
    mkdir /srv/deploy-keys/ && \
    mv /srv/config /root/.ssh/ && \
    chmod 0400 /root/.ssh/config

ENTRYPOINT ["/srv/entrypoint.sh"]
