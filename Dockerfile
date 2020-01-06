FROM phusion/baseimage
MAINTAINER xebec <xebecproject@xebec.site>

ARG USER_ID
ARG GROUP_ID

ENV HOME /xebec

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
RUN groupadd -g ${GROUP_ID} xebec
RUN useradd -u ${USER_ID} -g xebec -s /bin/bash -m -d /xebec xebec

RUN chown xebec:xebec -R /xebec

ADD https://github.com/xebecproject/xebec/releases/download/v0.14.0.6/xebec-0.14.0.6-x86_64-linux-gnu.tar.gz  /tmp/
RUN tar -xvf /tmp/xebec-*.tar.gz -C /tmp/
RUN cp /tmp/xebec*/bin/*  /usr/local/bin
RUN rm -rf /tmp/xebec*

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# For some reason, docker.io (0.9.1~dfsg1-2) pkg in Ubuntu 14.04 has permission
# denied issues when executing /bin/bash from trusted builds.  Building locally
# works fine (strange).  Using the upstream docker (0.11.1) pkg from
# http://get.docker.io/ubuntu works fine also and seems simpler.
USER xebec

VOLUME ["/xebec"]

EXPOSE 28280 27270 27271 27271

WORKDIR /xebec

CMD ["xebec_oneshot"]
