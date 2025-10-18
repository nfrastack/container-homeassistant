# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
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
    HOMEASSISTANT_VERSION="2025.10.3" \
    HOMEASSISTANT_CLI_VERSION="4.41.0" \
    GO2RTC_VERSION="v1.9.10" \
    JEMALLOC_VERSION="5.3.0" \
    PYTHON_VERSION="3.13.9" \
    GO2RTC_REPO_URL="https://github.com/AlexxIT/go2rtc" \
    HOMEASSISTANT_CLI_REPO_URL="https://github.com/home-assistant/cli" \
    HOMEASSISTANT_REPO_URL="https://github.com/home-assistant/core" \
    JEMALLOC_REPO_URL="https://github.com/jemalloc/jemalloc" \
    HOMEASSISTANT_COMPONENTS=" \
                                environment_canada, \
                                esphome, \
                                garminconnect, \
                                github, \
                                jellyfin, \
                                meater, \
                                mqtt, \
                                roku, \
                                tuya, \
                                #xbox, \
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
                                "

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    HOMEASSISTANT_USER=${HOMEASSISTANT_USER:-"homeassistant"} \
    HOMEASSISTANT_GROUP=${HOMEASSISTANT_GROUP:-"homeassistant"} \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED=homeassistant \
    NGINX_WORKER_PROCESSES=1 \
    IMAGE_NAME=nfrastack/homeassistant

RUN echo "" && \
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
                                    #py3-libcec \
                                    socat \
                                    tiff \
                                " \
    \
    HOMEASSISTANT_BUILD_DEPS_ALPINE=" \
                                        build-base \
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
                                    " \
                                && \
    \
    HOMEASSISTANTCLI_BUILD_DEPS_ALPINE=" \
                                        " \
                                        && \
    \
    JEMALLOC_BUILD_DEPS_ALPINE=" \
                                    autoconf \
                                    make \
                                " \
                                && \
    PYTHON_BUILD_DEPS_ALPINE="  \
                                bluez-dev \
                                bzip2-dev \
                                #dpkg-dev \
                                #dpkg \
                                findutils \
                                gcc \
                                gdbm-dev \
                                gnupg \
                                libc-dev \
                                libffi-dev \
                                libnsl-dev \
                                libtirpc-dev \
                                linux-headers \
                                make \
                                ncurses-dev \
                                openssl-dev \
                                pax-utils \
                                readline-dev \
                                sqlite-dev \
                                tar \
                                tcl-dev \
                                tk \
                                tk-dev \
                                util-linux-dev \
                                xz \
                                xz-dev \
                                zlib-dev \
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
                        JEMALLOC_BUILD_DEPS \
                        PYTHON_BUILD_DEPS \
                        && \
    mkdir -p /usr/src/python && \
    curl -sSL https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz | tar xvfJ - --strip 1 -C /usr/src/python && \
    cd /usr/src/python && \
    case "$(container_info distro)" in \
        alpine ) clib=musl ;; \
        debian|ubuntu ) clib=gnu ;; \
    esac ; \
	./configure \
		--build="$(uname -m)-linux-${clib}" \
		--enable-loadable-sqlite-extensions \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-lto \
		--with-ensurepip \
        && \
    EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000" && \
    LDFLAGS="${LDFLAGS:--Wl},--strip-all" && \
    case "$(container_info arch)" in \
        x86_64 | aarch64) EXTRA_CFLAGS="${EXTRA_CFLAGS:-} -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer" ;; \
        * ) EXTRA_CFLAGS="${EXTRA_CFLAGS:-} -fno-omit-frame-pointer" ;; \
    esac ; \
	make \
             -j $(nproc) \
    		"EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" \
	    	"LDFLAGS=${LDFLAGS:-}" \
	        && \
    rm python && \
	make \
            -j $(nproc) \
    		"EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" \
    		"LDFLAGS=${LDFLAGS:--Wl},-rpath='\$\$ORIGIN/../lib'" \
    		python \
    	    && \
	make install && \
	find /usr/local -depth \
                            \( \
	                    		\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
	                    		-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \
	                    	\) -exec rm -rf '{}' + \
	                        && \
	\
	find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' \
        		| tr ',' '\n' \
        		| sort -u \
        		| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        		| xargs -rt apk add --no-network --virtual .python-rundeps \
        	    && \
	export PYTHONDONTWRITEBYTECODE=1 && \
    \
    for src in idle3 pip3 pydoc3 python3 python3-config; do \
		dst="$(echo "$src" | tr -d 3)"; \
		[ -s "/usr/local/bin/$src" ]; \
		[ ! -e "/usr/local/bin/$dst" ]; \
		ln -svT "$src" "/usr/local/bin/$dst"; \
	done && \
    \
    echo -e "[global]\ndisable-pip-version-check = true\nextra-index-url = https://wheels.home-assistant.io/musllinux-index/\nno-cache-dir = false\nprefer-binary = true" > /etc/pip.conf && \
    pip install --break-system-packages uv && \
    \
    container_build_log add "Python" "${PYTHON_VERSION}" "python.org" && \
    \
    clone_git_repo "${JEMALLOC_REPO_URL}" "${JEMALLOC_VERSION}" && \
    ./autogen.sh \
                --with-lg-page=16 \
                && \
    make -j "$(nproc)" && \
    make install_lib_shared install_bin && \
    \
    container_build_log add "JemAlloc" "${JEMALLOC_VERSION}" "${JEMALLOC_REPO_URL}" && \
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
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2" \
        MALLOC_CONF="background_thread:true,metadata_thp:auto,dirty_decay_ms:20000,muzzy_decay_ms:20000" \
            uv pip install \
                --compile \
                -r requirements.txt \
                -r requirements_custom.txt \
                && \
    \
    cd /usr/src/homeassistant && \
    chown -R "${HOMEASSISTANT_USER}":"${HOMEASSISTANT_GROUP}" /opt/homeassistant && \
    sudo -u "${HOMEASSISTANT_USER}" \
        sed -i \
            -e '/"google_translate",/d' \
            -e '/"met",/d' \
            -e '/"radio_browser",/d' \
            -e '/"shopping_list",/d' \
            /opt/homeassistant/lib/python$(python3 --version | awk '{print $2}' | cut -d . -f 1-2)/site-packages/homeassistant/components/onboarding/views.py && \
    \
    python3 -m venv /opt/homeassistant && \
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
    cp requirements_custom.txt /container/build/"${IMAGE_NAME/\//_}"/ && \
    export MAKEFLAGS="-j$(nproc) -l$(nproc)" && \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2" \
        CFLAGS="-Wno-int-conversion" \
        MALLOC_CONF="background_thread:true,metadata_thp:auto,dirty_decay_ms:20000,muzzy_decay_ms:20000" \
        sudo -u "${HOMEASSISTANT_USER}" \
            uv pip install \
                --compile \
                -r requirements.txt \
                -r requirements_custom.txt \
                && \
    \
    cd /usr/src/homeassistant && \
    chown -R "${HOMEASSISTANT_USER}":"${HOMEASSISTANT_GROUP}" /opt/homeassistant && \
    \
    sudo -u "${HOMEASSISTANT_USER}" \
        sed -i \
                    -e '/"google_translate",/d' \
                    -e '/"met",/d' \
                    -e '/"radio_browser",/d' \
                    -e '/"shopping_list",/d' \
                /opt/homeassistant/lib/python$(python3 --version | awk '{print $2}' | cut -d . -f 1-2)/site-packages/homeassistant/components/onboarding/views.py && \
    \
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
                    JEMALLOC_BUILD_DEPS \
                    PYTHON_BUILD_DEPS \
                    && \
    rm -rf \
            /root/go \
            && \
    package cleanup

COPY rootfs /
