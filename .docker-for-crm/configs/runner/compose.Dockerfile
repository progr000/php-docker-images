FROM ubuntu:20.04

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --fix-missing curl

#ARG UID
#ARG GID
#ENV UID=${UID}
#ENV GID=${GID}
ENV UID=1000
ENV GID=1000
RUN curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 \
    && chmod +x /usr/local/bin/gitlab-runner \
    && groupadd -g ${GID} --system gitlab-runner \
    && useradd -g gitlab-runner -u ${UID} --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash \
    && rm /home/gitlab-runner/.bash_logout \
    && mkdir -p /home/gitlab-runner/.gitlab-runner \
    && touch /home/gitlab-runner/.gitlab-runner/config.toml \
    && gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner \
    && gitlab-runner start

RUN apt-get update && apt-get install -y --fix-missing docker docker-compose sudo
RUN echo "gitlab-runner   ALL=(ALL:ALL) NOPASSWD: /usr/bin/dockerd" >> /etc/sudoers \
    && echo "gitlab-runner   ALL=(ALL:ALL) NOPASSWD: /usr/bin/dockerd &" >> /etc/sudoers \
    && usermod -a -G docker gitlab-runner


#curl -fsSL https://get.docker.com/rootless > /tmp/rootless
#chmod +x /tmp/rootless
#export SKIP_IPTABLES=1 && /tmp/rootless

# Set user adn workdir
USER gitlab-runner

# run
CMD ["sh", "/run.sh"]
#CMD ["/bin/bash"]