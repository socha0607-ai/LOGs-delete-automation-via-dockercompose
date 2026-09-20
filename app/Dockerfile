FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bash \
    tar \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./scripts/ /app/scripts/

RUN useradd -u 1001 -m runtimeuser
RUN chmod +x /app/scripts/entrypoint.sh /app/scripts/backup.sh \
    && chown -R runtimeuser:runtimeuser /app

USER runtimeuser

ENTRYPOINT ["/bin/bash", "/app/scripts/entrypoint.sh"]
