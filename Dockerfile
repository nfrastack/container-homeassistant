ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.20

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG BASHIO_VERSION
ARG HOMEASSISTANT_COMPONENTS
ARG HOMEASSISTANT_CLI_VERSION
ARG HOMEASSISTANT_VERSION
ARG JEMALLOC_VERSION
ARG LIBCEC_VERSION
ARG PICOTTS_VERSION
ARG SSOCR_VERSION
ARG TELLDUS_VERSION
ARG TEMPIO_VERSION
ARG HOMEASSISTANT_COMPONENTS
ARG HOMEASSISTANT_MODULES

ENV HOMEASSISTANT_VERSION=${HOMEASSISTANT_VERSION:-"2024.6.4"} \
    HOMEASSISTANT_CLI_VERSION=${HOMEASSISTANT_CLI_VERSION:-"4.34.0"} \
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
                                                            environment_canada, \
                                                            esphome, \
                                                            file_upload, \
                                                            ffmpeg, \
                                                            frontend, \
                                                            garmin_connect, \
                                                            github, \
                                                            hacs, \
                                                            haffmpeg, \
                                                            http, \
                                                            image, \
                                                            isal, \
                                                            jellyfin, \
                                                            logbook, \
                                                            meater, \
                                                            midea_ac, \
                                                            mobile_app, \
                                                            mqtt, \
                                                            openweathermap, \
                                                            recorder, \
                                                            roku, \
                                                            ssdp, \
                                                            stream, \
                                                            tts, \
                                                            tuya, \
                                                            utility_meter, \
                                                            xbox, \
                                                            zha \
                                                            "} \
    HOMEASSISTANT_MODULES_CORE=${HOMEASSISTANT_MODULES_CORE:-" \
                                                                homeassistant.auth.mfa_modules.totp \
                                                                psycopg2 \
                                                                "} \
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
    IMAGE_NAME=tiredofit/homeassistant

RUN source /assets/functions/00-container && \
    set -x && \
    addgroup -S -g 4663 homeassistant && \
    adduser -S -D -H -u 4663 -G homeassistant -g "Home Assistant" homeassistant && \
    package install .container-run-deps \
                        #bind-tools \
                        git \
                        grep \
                        hwdata-usb \
                        iperf3 \
                        iputils \
                        jq \
                        libcap \
                        libgpiod \
                        libpulse \
                        libstdc++ \
                        libxslt \
                        libzbar \
                        mariadb-connector-c \
                        net-tools \
                        nmap \
                        openssh-client \
                        openssl \
                        pianobar \
                        py3-libcec \
                        socat \
                        tiff \
                    && \
    \
    package install .jemalloc-build-deps \
                        autoconf \
                        make \
                        && \
    \
    package install .homeassistant-build-deps \
                        #cargo \
                        #cups-dev \
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
    #package install .picotts-build-deps \
    #                    automake \
    #                    autoconf \
    #                    build-base \
    #                    libtool \
    #                    popt-dev \
    #                && \
    #\
    #package install .picotts-run-deps \
    #                    popt \
    #                && \
    #\
    #package install .ssocr-build-deps \
    #                    build-base \
    #                    imlib2-dev \
    #                    libx11-dev \
    #                && \
    #\
    #package install .ssocr-run-deps \
    #                    imlib2 \
    #                && \
    #\
    #package install .telldus-build-deps \
    #                    argp-standalone \
    #                    build-base \
    #                    cmake \
    #                    confuse-dev \
    #                    doxygen \
    #                    libftdi1-dev \
    #                && \
    \
    #package install .telldus-run-deps \
    #                    confuse \
    #                    libftdi1 \
    #                && \
    \
    #package install .tempio-build-deps \
    #                    go \
    #                && \
    #\
    echo -e "[global]\ndisable-pip-version-check = true\nextra-index-url = https://wheels.home-assistant.io/musllinux-index/\nno-cache-dir = false\nprefer-binary = true" > /etc/pip.conf && \

    clone_git_repo "${JEMALLOC_REPO_URL}" "${JEMALLOC_VERSION}" && \
    ./autogen.sh \
                --with-lg-page=16 \
                && \
    make -j "$(nproc)" && \
    make install_lib_shared install_bin && \
    \
    #clone_git_repo "${BASHIO_REPO_URL}" "${BASHIO_VERSION}" && \
    #mv /usr/src/bashio/lib /usr/lib/bashio && \
    #ln -sf /usr/lib/bashio/bashio /usr/bin/bashio && \
    \
    cd /usr/src/ && \
    clone_git_repo "${HOMEASSISTANT_REPO_URL}" "${HOMEASSISTANT_VERSION}" homeassistant && \
    #pip install --break-system-packages \
    #                faust-cchardet==2.1.19 \
    #                && \
    \
    #NUMPY_VER=$(grep "numpy" requirements_all.txt) && \
    #PYCUPS_VER=$(grep "pycups" requirements_all.txt | sed 's|.*==||') && \
    \
    python3 -m venv /opt/homeassistant && \
    #/opt/homeassistant/bin/pip install  && \
    #pip install --break-system-packages "${NUMPY_VER}" && \
    #pip install --break-system-packages pycups==${PYCUPS_VER}
    cd /usr/src/homeassistant && \
    export HOMEASSISTANT_COMPONENTS_CORE=$(echo components.${HOMEASSISTANT_COMPONENTS_CORE} | sed -e 's|, |\| components.|g' -e 's| ||g') && \
    echo "## Core" >> requirements_custom.txt && \
    awk -v RS= '$0~ENVIRON["HOMEASSISTANT_COMPONENTS_CORE"]' requirements_all.txt >> requirements_custom.txt && \
    echo "## Core Modules" >> requirements_custom.txt && \
    awk -v RS= '$0~ENVIRON["HOMEASSISTANT_MODULES_CORE"]' requirements_all.txt >> requirements_custom.txt && \
    if [ -n "${HOMEASSISTANT_COMPONENTS}" ]; then \
        echo "## User Components" >> requirements_custom.txt ; \
        export HOMEASSISTANT_COMPONENTS=$(echo components.${HOMEASSISTANT_COMPONENTS} | sed -e 's|, |\| components.|g' -e 's| ||g') ; \
        awk -v RS= '$0~ENVIRON["HOMEASSISTANT_COMPONENTS"]' requirements_all.txt >> requirements_custom.txt ; \
    fi; \
    if [ -n "${HOMEASSISTANT_MODULES}" ]; then \
        echo "## User Modules" >> requirements_custom.txt ; \
        awk -v RS= '$0~ENVIRON["HOMEASSISTANT_MODULES"]' requirements_all.txt >> requirements_custom.txt ; \
    fi; \
    echo "homeassistant==${HOMEASSISTANT_VERSION}" >> requirements_custom.txt && \
    mkdir -p /assets/.changelogs && \
    cp requirements_custom.txt /assets/.changelogs && \
    export MAKEFLAGS="-j$(nproc) -l$(nproc)" && \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2" \
        MALLOC_CONF="background_thread:true,metadata_thp:auto,dirty_decay_ms:20000,muzzy_decay_ms:20000" \
        /opt/homeassistant/bin/pip install \
            --compile \
            --no-warn-script-location \
            -r requirements.txt \
            -r requirements_custom.txt \
            git+https://github.com/rhasspy/webrtc-noise-gain \
            ## HACK Until a better version >1.2.3 of webrtc-noise-gain \
            && \
    \


    #pip install --break-system-packages \
    #        --compile \
    #        aiogithubapi>=21.11.0 \
    #        aiohttp>=3.8.3,\<4.0 \
    #        aiohttp_cors==0.7.0 \
    #        async-timeout>=4.0.2 \
    #        asynctest==0.13.0 \
    #        awscli==1.33.13 \
    #        colorlog==6.8.2 \
    #        setuptools==70.1.0 \
    #        garminconnect \
    #        msmart \
    #        croniter \
    #        && \
    sed -i \
            -e '/"google_translate",/d' \
            -e '/"met",/d' \
            -e '/"radio_browser",/d' \
            -e '/"shopping_list",/d' \
            /opt/homeassistant/lib/python$(python3 --version | awk '{print $2}' | cut -d . -f 1-2)/site-packages/homeassistant/components/onboarding/views.py && \
    \
    cd /usr/src && \
    clone_git_repo "${HOMEASSISTANT_CLI_REPO_URL}" "${HOMEASSISTANT_CLI_VERSION}" && \
    go build \
            -ldflags '-s' \
            -o /usr/bin/ha-cli \
            && \
    \
    #clone_git_repo "${PICOTTS_REPO_URL}" "${PICOTTS_VERSION}" && \
    #cd pico && \
    #./autogen.sh && \
    #./configure \
    #    --disable-static \
    #    && \
    #make && \
    #make install && \
    #\
    #clone_git_repo "${SSOCR_REPO_URL}" "${SSOCR_VERSION}" && \
    #make -j"$(nproc)" && \
    #cp -R ssocr /usr/bin/ssocr && \
    #\
    #clone_git_repo "${TELLDUS_REPO_URL}" "${TELLDUS_VERSION}" && \
    #git apply ../patches/telldus-gcc11.patch && \
    #git apply ../patches/telldus-alpine.patch && \
    #cd telldus-core && \
    #cmake . \
    #        -DBUILD_LIBTELLDUS-CORE=ON \
    #        -DBUILD_TDADMIN=OFF \
    #        -DBUILD_TDTOOL=OFF \
    #        -DFORCE_COMPILE_FROM_TRUNK=ON \
    #        -DGENERATE_MAN=OFF \
    #        && \
    #make -j"$(nproc)" && \
    #make install && \
    \
    #clone_git_repo "${TEMPIO_REPO_URL}" "${TEMPIO_VERSION}" && \
    #go build -ldflags '-s' -o /usr/bin/tempio && \
    \
    package remove \
                    .jemalloc-build-deps \
                    .homeassistant-build-deps \
                    .homeassistant-cli-build-deps \
                    #.picotts-build-deps \
                    #.ssocr-build-deps \
                    #.telldus-build-deps \
                    #.tempio-build-deps \
                    && \
    package cleanup

COPY install /
