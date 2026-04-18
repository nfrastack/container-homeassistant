# SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="Home Assistant" \
        org.opencontainers.image.description="Home Automation Platform" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/homeassistant" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-homeassistant/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-homeassistant.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    HOMEASSISTANT_VERSION="2026.4.3" \
    HOMEASSISTANT_CLI_VERSION="5.0.0" \
    GO2RTC_VERSION="v1.9.14" \
    MIMALLOC_VERSION="v3.0.11" \
    PYTHON_VERSION="3.14.4" \
    GO2RTC_REPO_URL="https://github.com/AlexxIT/go2rtc" \
    HOMEASSISTANT_CLI_REPO_URL="https://github.com/home-assistant/cli" \
    HOMEASSISTANT_REPO_URL="https://github.com/home-assistant/core" \
    MIMALLOC_REPO_URL="https://github.com/microsoft/mimalloc" \
    HOMEASSISTANT_COMPONENTS=" \
                                environment_canada, \
                                esphome, \
                                github, \
                                jellyfin, \
                                meater, \
                                mqtt, \
                                roku, \
                                tuya, \
                                zha \
                             " \
    HOMEASSISTANT_COMPONENTS_CORE=" \
                                    accuweather, \
                                    assist_pipeline, \
                                    backup, \
                                    bluetooth,\
                                    bluetooth_tracker, \
                                    camera, \
                                    check_config, \
                                    cloud, \
                                    compensation, \
                                    conversation, \
                                    dhcp, \
                                    discovery, \
                                    ffmpeg, \
                                    file_upload, \
                                    frontend, \
                                    generic, \
                                    haffmpeg, \
                                    http, \
                                    image, \
                                    isal, \
                                    logbook, \
                                    mobile_app, \
                                    openweathermap, \
                                    otp, \
                                    qrcode, \
                                    recorder, \
                                    ssdp, \
                                    stream, \
                                    tts, \
                                    utility_meter, \
                                  " \
    HOMEASSISTANT_MODULES \
    HOMEASSISTANT_MODULES_CORE=" \
                                 homeassistant.auth.mfa_modules.totp, \
                                 psycopg2 \
                               " \
    HOMEASSISTANT_USER \
    HOMEASSISTANT_GROUP

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    HOMEASSISTANT_USER=${HOMEASSISTANT_USER:-"homeassistant"} \
    HOMEASSISTANT_GROUP=${HOMEASSISTANT_GROUP:-"homeassistant"} \
    IMAGE_NAME=nfrastack/homeassistant \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-homeassistant/"

RUN echo "" && \
    BUILD_ENV=" \
                10-nginx/ENABLE_NGINX=FALSE \
                10-nginx/NGINX_SITE_ENABLED='homeassistant' \
                10-nginx/NGINX_MODE=proxy \
                10-nginx/NGINX_PROXY_URL='http://localhost:[env:LISTEN_PORT]' \
              " \
              && \
    CONTAINER_RUN_DEPS_ALPINE=" \
                                    git \
                                    grep \
                                    hwdata-usb \
                                    iperf3 \
                                    iputils \
                                    jq \
                                    libcap \
                                    libpulse \
                                    libstdc++ \
                                    libxslt \
                                    libzbar \
                                    mariadb-connector-c \
                                    net-tools \
                                    nmap \
                                    openssl \
                                    pianobar \
                                    socat \
                                    tiff \
                                " \
                                && \
    \
    HOMEASSISTANT_BUILD_DEPS_ALPINE=" \
                                        bluez-dev \
                                        build-base \
                                        clang \
                                        compiler-rt \
                                        cython \
                                        ffmpeg-dev \
                                        g++ \
                                        gcc \
                                        gdbm-dev \
                                        gnupg \
                                        isa-l-dev \
                                        jpeg-dev \
                                        libc-dev \
                                        libffi-dev \
                                        libjpeg-turbo-dev \
                                        libnsl-dev \
                                        libtirpc-dev \
                                        linux-headers \
                                        make \
                                        mariadb-connector-c-dev \
                                        musl-dev \
                                        openblas-dev \
                                        pax-utils \
                                        postgresql-dev \
                                        scanelf \
                                        sqlite-dev \
                                        speex-dev \
                                        speexdsp-dev \
                                        tar \
                                        tcl-dev \
                                        tk \
                                        tk-dev \
                                        util-linux-dev \
                                        xz-dev \
                                        zlib-dev \
                                        zlib-ng-dev \
                                    " \
                                    && \
    \
    HOMEASSISTANT_RUN_DEPS_ALPINE=" \
                                        eudev-libs \
                                        ffmpeg \
                                        isa-l \
                                        libturbojpeg \
                                        mariadb-connector-c \
                                        postgresql-client \
                                        zlib-ng \
                                        xz \
                                    " \
                                  && \
    \
    HOMEASSISTANTCLI_BUILD_DEPS_ALPINE=" \
                                       " \
                                       && \
    \
    MIMALLOC_BUILD_DEPS_ALPINE=" \
                                    cmake \
                                    make \
                                " \
                                && \
    \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user homeassistant 4663 homeassistant 4663 /opt/homeassistant && \
    package update && \
    package upgrade && \
    package install \
                        CONTAINER_RUN_DEPS \
                        HOMEASSISTANT_BUILD_DEPS \
                        HOMEASSISTANT_RUN_DEPS \
                        HOMEASSISTANTCLI_BUILD_DEPS \
                        MIMALLOC_BUILD_DEPS \
                        && \
    package build python "${PYTHON_VERSION}" && \
    echo -e "[global]\ndisable-pip-version-check = true\nextra-index-url = https://wheels.home-assistant.io/musllinux-index/\nno-cache-dir = false\nprefer-binary = true" > /etc/pip.conf && \
    pip install --break-system-packages uv && \
    \
    clone_git_repo "${MIMALLOC_REPO_URL}" "${MIMALLOC_VERSION}" && \
    mkdir -p out/release && \
    cd out/release && \
    cmake ../.. && \
    make && \
    make install && \
    container_build_log add "MimAlloc" "${MIMALLOC_VERSION}" "${MIMALLOC_REPO_URL}" && \
    \
    clone_git_repo "${HOMEASSISTANT_REPO_URL}" "${HOMEASSISTANT_VERSION}" /usr/src/homeassistant && \
    uv venv /opt/homeassistant && \
    chown -R "${HOMEASSISTANT_USER}":"${HOMEASSISTANT_GROUP}" /opt/homeassistant && \
    source /opt/homeassistant/bin/activate && \
    cd /usr/src/homeassistant && \
    echo "homeassistant==${HOMEASSISTANT_VERSION}" >> requirements_custom.txt && \
    export HOMEASSISTANT_COMPONENTS_CORE=$(echo components.${HOMEASSISTANT_COMPONENTS_CORE} | sed -e 's|, |\| components.|g' -e 's| ||g') && \
    echo "## Core" >> requirements_custom.txt && \
    awk -v RS= '$0~ENVIRON["HOMEASSISTANT_COMPONENTS_CORE"]' requirements_all.txt >> requirements_custom.txt && \
    echo "## Core Modules" >> requirements_custom.txt && \
    export HOMEASSISTANT_MODULES_CORE=$(echo ${HOMEASSISTANT_MODULES_CORE} | sed -e 's|, |\| |g' -e 's| ||g') && \
    awk -v RS= '$0~ENVIRON["HOMEASSISTANT_MODULES_CORE"]' requirements_all.txt >> requirements_custom.txt && \
    if [ -n "${HOMEASSISTANT_COMPONENTS}" ]; then \
        echo "## User Components" >> requirements_custom.txt ; \
        export HOMEASSISTANT_COMPONENTS=$(echo components.${HOMEASSISTANT_COMPONENTS} | sed -e 's|, |\| components.|g' -e 's| ||g') ; \
        awk -v RS= '$0~ENVIRON["HOMEASSISTANT_COMPONENTS"]' requirements_all.txt >> requirements_custom.txt ; \
    fi; \
    if [ -n "${HOMEASSISTANT_MODULES}" ]; then \
        echo "## User Modules" >> requirements_custom.txt ; \
        export HOMEASSISTANT_MODULES=$(echo ${HOMEASSISTANT_MODULES} | sed -e 's|, |\| |g' -e 's| ||g') ; \
        awk -v RS= '$0~ENVIRON["HOMEASSISTANT_MODULES"]' requirements_all.txt >> requirements_custom.txt ; \
    fi; \
    sed \
        -i \
            -e "/streamlabswater/d" \
        requirements_custom.txt && \
    cp requirements_custom.txt /container/build/"${IMAGE_NAME/\//_}"/ && \
    export MAKEFLAGS="-j$(nproc) -l$(nproc)" && \
    LD_PRELOAD="/usr/local/lib/libmimalloc.so.2" \
        CFLAGS="-Wno-int-conversion" \
        MALLOC_CONF="background_thread:true,metadata_thp:auto,dirty_decay_ms:20000,muzzy_decay_ms:20000" \
        CC=clang \
        CXX=clang++ \
            uv pip install \
                --compile \
                -r requirements.txt \
                -r requirements_custom.txt \
                && \
    chown -R "${HOMEASSISTANT_USER}":"${HOMEASSISTANT_GROUP}" /opt/homeassistant && \
    sudo -u "${HOMEASSISTANT_USER}" \
        sed -i \
                -e '/"google_translate",/d' \
                -e '/"met",/d' \
                -e '/"radio_browser",/d' \
                -e '/"shopping_list",/d' \
            /opt/homeassistant/lib/python$(/opt/homeassistant/bin/python3 --version | awk '{print $2}' | cut -d . -f 1-2)/site-packages/homeassistant/components/onboarding/views.py && \
    container_build_log add "Home Assistant" "${HOMEASSISTANT_VERSION}" "${HOMEASSISTANT_REPO_URL}" && \
    \
    package build go && \
    clone_git_repo "${HOMEASSISTANT_CLI_REPO_URL}" "${HOMEASSISTANT_CLI_VERSION}" && \
    go build \
            -ldflags '-s' \
            -o /usr/local/bin/ha-cli \
            && \
    \
    container_build_log add "Home Assistant CLI" "${HOMEASSISTANT_CLI_VERSION}" "${HOMEASSISTANT_CLI_REPO_URL}" && \
    clone_git_repo "${GO2RTC_REPO_URL}" "${GO2RTC_VERSION}" /usr/src/go2rtc && \
    export CGO_ENABLED=0 && \
    go build \
            -v \
            -ldflags '-s -w' \
            -o /usr/local/bin/go2rtc \
            && \
    container_build_log add "GO2RTC" "${GO2RTC_VERSION}" "${GO2RTC_REPO_URL}" && \
    package remove \
                    GO2RTC_BUILD_DEPS \
                    HOMEASSISTANT_BUILD_DEPS \
                    HOMEASSISTANTCLI_BUILD_DEPS \
                    MIMALLOC_BUILD_DEPS \
                    && \
    rm -rf \
            /root/go \
            && \
    package cleanup

COPY rootfs /
