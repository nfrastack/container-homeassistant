ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.19

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG BASHIO_VERSION
ARG HOMEASSISTANT_CLI_VERSION
ARG HOMEASSISTANT_VERSION
ARG JEMALLOC_VERSION
ARG LIBCEC_VERSION
ARG PICOTTS_VERSION
ARG SSOCR_VERSION
ARG TELLDUS_VERSION
ARG TEMPIO_VERSION

ENV HOMEASSISTANT_VERSION=${HOMEASSISTANT_VERSION:-"2024.1.6"} \
    HOMEASSISTANT_CLI_VERSION=${HOMEASSISTANT_CLI_VERSION:-"4.29.0"} \
    BASHIO_VERSION=${BASHIO_VERSION:-"v0.16.2"} \
    JEMALLOC_VERSION=${JEMALLOC_VERSION:-"5.3.0"} \
    PICOTTS_VERSION=${PICOTTS_VERSION:-"21089d223e177ba3cb7e385db8613a093dff74b5"} \
    SSOCR_VERSION=${SSOCR_VERSION:-"v2.23.1"} \
    TELLDUS_VERSION=${TELLDUS_VERSION:-"2598bbed16ffd701f2a07c99582f057a3decbaf3"} \
    TEMPIO_VERSION=${TEMPIO_VERSION:-"d7f190abd97f6737c3e8f1f0cbccfc0dff54a397"} \
    HOMEASSISTANT_REPO_URL=${HOMEASSISTANT_REPO_URL:-"https://github.com/home-assistant/core"} \
    HOMEASSISTANT_CLI_REPO_URL=${HOMEASSISTANT_CLI_REPO_URL:-"https://github.com/home-assistant/cli"} \
    BASHIO_REPO_URL=${BASHIO_REPO_URL:-"https://github.com/hassio-addons/bashio"} \
    JEMALLOC_REPO_URL=${JEMALLOC_REPO_URL:-"https://github.com/jemalloc/jemalloc"} \
    PICOTTS_REPO_URL=${PICOTTS_REPO_URL:-"https://github.com/ihuguet/picotts"} \
    SSOCR_REPO_URL=${SSOCR_REPO_URL:-"https://github.com/auerswal/ssocr"} \
    TELLDUS_REPO_URL=${TELLDUS_REPO_URL:-"https://github.com/telldus/telldus"} \
    TEMPIO_REPO_URL=${TEMPIO_REPO_URL:-"https://github.com/home-assistant/tempio"} \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED=homeassistant \
    NGINX_WORKER_PROCESSES=1 \
    IMAGE_NAME=tiredofit/homeassistant \
    IMAGE_REPO_URL=https://github.com/tiredofit/docker-homeassistant

COPY patches /usr/src/patches

RUN source /assets/functions/00-container && \
    set -x && \
    addgroup -S -g 4663 homeassistant && \
    adduser -S -D -H -u 4663 -G homeassistant -g "Home Assistant" homeassistant && \
    package install .container-run-deps \
                        bind-tools \
                        bluez \
                        bluez-deprecated \
                        bluez-libs \
                        eudev-libs \
                        ffmpeg \
                        git \
                        grep \
                        hwdata-usb \
                        iperf3 \
                        jq \
                        libgpiod \
                        libjpeg-turbo \
                        libpulse \
                        libstdc++ \
                        libzbar \
                        mariadb-connector-c \
                        net-tools \
                        nmap \
                        openssh-client \
                        pianobar \
                        pulseaudio-alsa \
                        py3-libcec \
                        socat \
                    && \
    \
    package install .homeassistant-build-deps \
                        ffmpeg-dev \
                        linux-headers \
                        mariadb-connector-c-dev \
                        postgresql-dev \
                        python3-dev \
                        py3-distutils-extra \
                        py3-pip \
                    && \
    \
    package install .homeassistant-run-deps \
                        mariadb-connector-c \
                        postgresql-client \
                        python3 \
                        py3-pip \
                    && \
    \
    package install .homeassistant-cli-build-deps \
                        go \
                    && \
    \
    package install .picotts-build-deps \
                        automake \
                        autoconf \
                        build-base \
                        libtool \
                        popt-dev \
                    && \
    \
    package install .picotts-run-deps \
                        popt \
                    && \
    \
    package install .ssocr-build-deps \
                        build-base \
                        imlib2-dev \
                        libx11-dev \
                    && \
    \
    package install .ssocr-run-deps \
                        imlib2 \
                    && \
    \
    package install .telldus-build-deps \
                        argp-standalone \
                        build-base \
                        cmake \
                        confuse-dev \
                        doxygen \
                        libftdi1-dev \
                    && \
    \
    package install .telldus-run-deps \
                        confuse \
                        libftdi1 \
                    && \
    \
    package install .tempio-build-deps \
                        go \
                    && \
    \
    sleep 60 && \
    clone_git_repo "${JEMALLOC_REPO_URL}" "${JEMALLOC_VERSION}" && \
    ./autogen.sh \
                --with-lg-page=16 \
                && \
    make -j "$(nproc)" && \
    make install_lib_shared install_bin && \
    \
    clone_git_repo "${BASHIO_REPO_URL}" "${BASHIO_VERSION}" && \
    mv /usr/src/bashio/lib /usr/lib/bashio && \
    ln -sf /usr/lib/bashio/bashio /usr/bin/bashio && \
    \
    clone_git_repo "${HOMEASSISTANT_REPO_URL}" "${HOMEASSISTANT_VERSION}" homeassistant && \
    pip install --break-system-packages \
                    Brotli==1.1.0 \
                    faust-cchardet==2.1.19 \
                    mysqlclient==2.2.1 \
                    psycopg2==2.9.9 \
                    && \
    \
    pip install -r requirements.txt --break-system-packages && \
    ## HACK Until a better version >1.2.3 of webrtc-noise-gain
    pip install git+https://github.com/rhasspy/webrtc-noise-gain --break-system-packages && \
    pip install -r requirements_all.txt --break-system-packages && \
    pip3 install --only-binary=:all: -e ./ --break-system-packages && \
    python3 -m \
                compileall \
                homeassistant \
                && \
    \
    clone_git_repo "${HOMEASSISTANT_CLI_REPO_URL}" "${HOMEASSISTANT_CLI_VERSION}" && \
    go build \
            -ldflags '-s' \
            -o /usr/bin/ha-cli \
            && \
    \
    clone_git_repo "${PICOTTS_REPO_URL}" "${PICOTTS_VERSION}" && \
    cd pico && \
    ./autogen.sh && \
    ./configure \
        --disable-static \
        && \
    make && \
    make install && \
    \
    clone_git_repo "${SSOCR_REPO_URL}" "${SSOCR_VERSION}" && \
    make -j"$(nproc)" && \
    cp -R ssocr /usr/bin/ssocr && \
    \
    clone_git_repo "${TELLDUS_REPO_URL}" "${TELLDUS_VERSION}" && \
    git apply ../patches/telldus-gcc11.patch && \
    git apply ../patches/telldus-alpine.patch && \
    cd telldus-core && \
    cmake . \
            -DBUILD_LIBTELLDUS-CORE=ON \
            -DBUILD_TDADMIN=OFF \
            -DBUILD_TDTOOL=OFF \
            -DFORCE_COMPILE_FROM_TRUNK=ON \
            -DGENERATE_MAN=OFF \
            && \
    make -j"$(nproc)" && \
    make install && \
    \
    clone_git_repo "${TEMPIO_REPO_URL}" "${TEMPIO_VERSION}" && \
    go build -ldflags '-s' -o /usr/bin/tempio && \
    \
    package remove \
                    .homeassistant-build-deps \
                    .homeassistant-cli-build-deps \
                    .picotts-build-deps \
                    .ssocr-build-deps \
                    .telldus-build-deps \
                    .tempio-build-deps \
                    && \
    package cleanup

COPY install /