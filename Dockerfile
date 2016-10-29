FROM debian:jessie

ENV HEALTHCHECKS_USER="1000" HEALTHCHECKS_GROUP="1000"

RUN apt-get update && \
    apt-get dist-upgrade -y

RUN groupadd -g "$HEALTHCHECKS_GROUP" healthchecks && \
    useradd -u 1000 -m -d /home/healthchecks -s /bin/bash "$HEALTHCHECKS_USER"

RUN apt-get install -y python3 postgresql && \
    mkdir -p /healthchecks/webapps && \
    chown healthchecks:healthchecks -R /healthchecks && \
    cd /healthchecks && \
    virtualenv --python=python3 hc-venv && \
    git clone https://github.com/healthchecks/healthchecks.git /healthchecks && \
    pip install -r /healthchecks/requirements.txt

ENTRYPOINT ["docker-entrypoint.sh"]
