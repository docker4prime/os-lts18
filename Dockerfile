# docker file for os-rhel7 image ith systemd enabled
# escape=`


# ====================================
# build production image (final stage)
# ====================================
# base image
FROM ubuntu:18.04
MAINTAINER Fidy Andrianaivo (fidy@andrianaivo.org)
LABEL Description="Ubuntu LTS 18.04 base image"

# APP core dependencies
ARG REQUIRED_OS_PACKAGES="ansible curl git htop net-tools openssh-client openssh-server python-pip rsync sudo"
ARG OPTIONAL_OS_PACKAGES

# APP environments
ARG APP_NAME="os-lts18"
ENV APP_NAME ${APP_NAME}

# SYS environments
# -- timezone
ARG TZ="Europe/Vienna"
ENV TZ ${TZ}
# -- proxy
ARG HTTPS_PROXY=""
ENV http_proxy=${HTTPS_PROXY}
ENV https_proxy=${HTTPS_PROXY}

# copy files to root FS
COPY files/ /

# copy test files
COPY tests/ /tests/

# install os packages & setup system
RUN echo "export http_proxy=${HTTPS_PROXY}" >> /etc/profile \
    && echo "export https_proxy=${HTTPS_PROXY}" >> /etc/profile \
    && chmod +x /usr/bin/systemctl \
    && mkdir -p /run/sshd \
    && chmod 700 /root/.ssh \
    && chmod 600 /root/.ssh/id_ecdsa \
    && chmod 644 /root/.ssh/authorized_keys \
    && chmod 644 /root/.ssh/config \
    && apt update -y \
    && apt install -y ${REQUIRED_OS_PACKAGES} ${OPTIONAL_OS_PACKAGES} \
    && rm -rf /var/lib/apt/lists/* \
    && systemctl enable ssh

# expose proxy ports
EXPOSE 22

# use init as start command
CMD [ "/usr/bin/systemctl" ]


# eof
