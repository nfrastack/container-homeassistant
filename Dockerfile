ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.20-6.5.5

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}

LABEL org.opencontainers.image.title         "Home Assistant"
LABEL org.opencontainers.image.description   "Dockerized Home Automation Platform"
LABEL org.opencontainers.image.url           "https://hub.docker.com/r/tiredofit/homeassistant"
LABEL org.opencontainers.image.documentation "https://github.com/tiredofit/docker-homeassistant/blob/main/README.md"
LABEL org.opencontainers.image.source        "https://github.com/tiredofit/docker-homeassistant.git"
LABEL org.opencontainers.image.authors       "Dave Conroy <dave@tiredofit.ca>"
LABEL org.opencontainers.image.vendor        "Tired of I.T! <https://www.tiredofit.ca>"
LABEL org.opencontainers.image.licenses      "MIT"

ARG HOMEASSISTANT_CLI_VERSION
ARG HOMEASSISTANT_COMPONENTS
ARG HOMEASSISTANT_MODULES
ARG HOMEASSISTANT_VERSION
ARG JEMALLOC_VERSION

ENV HOMEASSISTANT_VERSION=${HOMEASSISTANT_VERSION:-"2024.11.2"} \
    HOMEASSISTANT_CLI_VERSION=${HOMEASSISTANT_CLI_VERSION:-"4.36.0"} \
    HOMEASSISTANT_COMPONENTS=${HOMEASSISTANT_COMPONENTS:-" \
                                                            environment_canada, \
                                                            esphome, \
                                                            garminconnect, \
                                                            github, \
                                                            jellyfin, \
                                                            meater, \
                                                            mqtt, \
                                                            roku, \
                                                            tuya, \
                                                            xbox, \
                                                            zha \
                                                            "} \
    \
    HOMEASSISTANT_COMPONENTS_CORE=${HOMEASSISTANT_COMPONENTS_CORE:-" \
                                                            accuweather, \
                                                            assist_pipeline,\
                                                            backup, \
                                                            bluetooth,\
                                                            bluetooth_tracker, \
                                                            camera, \
                                                            compensation, \
                                                            check_config, \
                                                            conversation, \
                                                            dhcp, \
                                                            discovery, \
                                                            file_upload, \
                                                            ffmpeg, \
                                                            frontend, \
                                                            haffmpeg, \
                                                            http, \
                                                            image, \
                                                            isal, \
                                                            logbook, \
                                                            mobile_app, \
                                                            openweathermap, \
                                                            recorder, \
                                                            ssdp, \
                                                            stream, \
                                                            tts, \
                                                            utility_meter, \
                                                            "} \
    HOMEASSISTANT_MODULES_CORE=${HOMEASSISTANT_MODULES_CORE:-" \
                                                                homeassistant.auth.mfa_modules.totp, \
                                                                psycopg2 \
                                                                "} \
    HOMEASSISTANT_USER=${HOMEASSISTANT_USER:-"homeassistant"} \
    HOMEASSISTANT_GROUP=${HOMEASSISTANT_GROUP:-"homeassistant"} \
    GO2RTC_VERSION=${GO2RTC_VERSION:-"v1.9.6"} \
    GOLANG_VERSION=${GOLAND_VERSION:-"1.23.3"} \
    JEMALLOC_VERSION=${JEMALLOC_VERSION:-"5.3.0"} \
    HOMEASSISTANT_REPO_URL=${HOMEASSISTANT_REPO_URL:-"https://github.com/home-assistant/core"} \
    HOMEASSISTANT_CLI_REPO_URL=${HOMEASSISTANT_CLI_REPO_URL:-"https://github.com/home-assistant/cli"} \
    GO2RTC_REPO_URL=${GO2RTC_REPO_URL:-"https://github.com/AlexxIT/go2rtc"} \
    JEMALLOC_REPO_URL=${JEMALLOC_REPO_URL:-"https://github.com/jemalloc/jemalloc"} \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED=homeassistant \
    NGINX_WORKER_PROCESSES=1 \
    IMAGE_NAME=tiredofit/homeassistant

RUN source /assets/functions/00-container && \
    set -x && \
    addgroup -S -g 4663 ${HOMEASSISTANT_GROUP} && \
    adduser -S -D -H -h /opt/homeassistant -u 4663 -G ${HOMEASSISTANT_GROUP} -g "Home Assistant" ${HOMEASSISTANT_USER} && \
    package install .container-run-deps \
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
                        py3-libcec \
                        socat \
                        tiff \
                    && \
    \
    package install .go2rtc-build-deps \
                        go \
                    && \
    \
    package install .jemalloc-build-deps \
                        autoconf \
                        make \
                        && \
    \
    package install .homeassistant-build-deps \
                        cython \
                        ffmpeg-dev \
                        gcc \
                        g++ \
                        linux-headers \
                        isa-l-dev \
                        jpeg-dev \
                        libffi-dev \
                        libjpeg-turbo-dev \
                        make \
                        mariadb-connector-c-dev \
                        musl-dev \
                        openblas-dev \
                        postgresql-dev \
                        python3-dev \
                        py3-distutils-extra \
                        py3-parsing \
                        py3-pip \
                        py3-setuptools \
                        py3-wheel \
                        zlib-dev \
                        zlib-ng-dev \
                    && \
    \
    package install .homeassistant-run-deps \
                        eudev-libs \
                        ffmpeg \
                        isa-l \
                        libturbojpeg \
                        mariadb-connector-c \
                        postgresql-client \
                        py3-brotli \
                        py3-mysqlclient \
                        py3-pip \
                        py3-psycopg2 \
                        python3 \
                        zlib-ng \
                    && \
    \
    package install .homeassistant-cli-build-deps \
                        go \
                    && \
    \
    echo -e "[global]\ndisable-pip-version-check = true\nextra-index-url = https://wheels.home-assistant.io/musllinux-index/\nno-cache-dir = false\nprefer-binary = true" > /etc/pip.conf && \
    pip install --break-system-packages uv && \
    \
    clone_git_repo "${JEMALLOC_REPO_URL}" "${JEMALLOC_VERSION}" && \
    ./autogen.sh \
                --with-lg-page=16 \
                && \
    make -j "$(nproc)" && \
    make install_lib_shared install_bin && \
    \
    cd /usr/src/ && \
    clone_git_repo "${HOMEASSISTANT_REPO_URL}" "${HOMEASSISTANT_VERSION}" homeassistant && \
    \
    uv venv /opt/homeassistant && \
    chown -R "${HOMEASSISTANT_USER}":"${HOMEASSISTANT_GROUP}" /opt/homeassistant && \
    cd /usr/src/homeassistant && \
    export HOMEASSISTANT_COMPONENTS_CORE=$(echo components.${HOMEASSISTANT_COMPONENTS_CORE} | sed -e 's|, |\| components.|g' -e 's| ||g') && \
    echo "## Core" >> requirements_custom.txt && \
    awk -v RS= '$0~ENVIRON["HOMEASSISTANT_COMPONENTS_CORE"]' requirements_all.txt >> requirements_custom.txt && \
    echo "## Core Modules" >> requirements_custom.txt && \
    export HOMEASSISTANT_MODULES_CORE=$(echo ${HOMEASSISTANT_MODULES_CORE} | sed -e 's|, |\| |g' -e 's| ||g') ; \
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
    echo "homeassistant==${HOMEASSISTANT_VERSION}" >> requirements_custom.txt && \
    mkdir -p /assets/.changelogs && \
    cp requirements_custom.txt /assets/.changelogs && \
    export MAKEFLAGS="-j$(nproc) -l$(nproc)" && \
    source /opt/homeassistant/bin/activate && \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2" \
        MALLOC_CONF="background_thread:true,metadata_thp:auto,dirty_decay_ms:20000,muzzy_decay_ms:20000" \
        sudo -u "${HOMEASSISTANT_USER}" \
            uv pip install \
                --compile \
                -r requirements.txt \
                -r requirements_custom.txt \
                && \
    \
    sudo -u "${HOMEASSISTANT_USER}" \
        sed -i \
                -e '/"google_translate",/d' \
                -e '/"met",/d' \
                -e '/"radio_browser",/d' \
                -e '/"shopping_list",/d' \
                /opt/homeassistant/lib/python$(python3 --version | awk '{print $2}' | cut -d . -f 1-2)/site-packages/homeassistant/components/onboarding/views.py && \
    \
    mkdir -p /usr/src/golang ; \
    curl -sSL https://dl.google.com/go/go${GOLANG_VERSION}.src.tar.gz | tar xvfz - --strip 1 -C /usr/src/golang ; \
    cd /usr/src/golang/src/ ; \
    ./make.bash 1>/dev/null ; \
    export GOROOT=/usr/src/golang/ ; \
    export PATH="/usr/src/golang/bin:$PATH" ; \
    \
    cd /usr/src && \
    clone_git_repo "${HOMEASSISTANT_CLI_REPO_URL}" "${HOMEASSISTANT_CLI_VERSION}" && \
    /usr/src/golang/bin/go build \
            -ldflags '-s' \
            -o /usr/local/bin/ha-cli \
            && \
    \
    clone_git_repo "${GO2RTC_REPO_URL}" "${GO2RTC_VERSION}" /usr/src/go2rtc && \
    /usr/src/golang/bin/go build \
            -v \
            -ldflags '-s -w' \
            -o /usr/local/bin/go2rtc \
            && \
    \
    package remove \
                    .go2rtc-build-deps \
                    .homeassistant-build-deps \
                    .homeassistant-cli-build-deps \
                    .jemalloc-build-deps \
                    && \
    package cleanup && \
    rm -rf \
            /root/.cache \
            /root/go \
            /usr/src/*

COPY install /
