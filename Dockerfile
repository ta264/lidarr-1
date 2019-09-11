FROM hotio/mono

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8686
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:8686 || exit 1

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libchromaprint-tools && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# install app
# https://github.com/lidarr/Lidarr/releases
RUN curl -fsSL "https://github.com/lidarr/Lidarr/releases/download/v0.7.0.1347/Lidarr.master.0.7.0.1347.linux.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /

ARG TAG
ENV TAG="${TAG}"
