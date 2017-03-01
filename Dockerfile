FROM gliderlabs/alpine:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
			org.label-schema.name="r10k-webhook" \
			org.label-schema.description="Docker Image for deploy control-repo by r10k, using Gogs repository and webhooks." \
			org.label-schema.url="https://github.com/drignoto" \
			org.label-schema.vcs-ref=$VCS_REF \
			org.label-schema.vcs-url="https://github.com/drignoto/r10k-webhook.git" \
			org.label-schema.vendor="Dr.IgNoTo & EolDavix" \
			org.label-schema.version=$VERSION \
			org.label-schema.schema-version="1.0" \
			maintainer="Antonio Sánchez Aguilar <dr.ignoto@gmail.com>" \
			org.label-schema.docker.cmd="docker run -p 9001:9001 -v /srv/puppetlabs:/etc/puppetlabs -v /srv/gogs-deploy:/srv/deploy-keys ignoto/r10k-webhook"

#VARS
ENV PORT=9001 SECRET="Changeme"

WORKDIR /srv

RUN apk-install git \
         ruby \
		     python \
		     ruby-dev \
		     openssh-client \
		     build-base \
		     py-pip \
		   && gem install r10k json --no-rdoc --no-ri \
		   && pip install web.py \
		   && apk del build-base

COPY code/* /srv/

RUN mkdir /root/.ssh/ /srv/deploy-keys/ \
	&& mv /srv/config /root/.ssh/ \
  && chmod 0400 /root/.ssh/config

ENTRYPOINT ["/srv/entrypoint.sh"]
