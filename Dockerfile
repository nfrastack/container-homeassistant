ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.20-6.5.10

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
ARG PYTHON_VERSION=3.13.4

ENV HOMEASSISTANT_VERSION=${HOMEASSISTANT_VERSION:-"2025.6.3"} \
    HOMEASSISTANT_CLI_VERSION=${HOMEASSISTANT_CLI_VERSION:-"4.37.0"} \
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
                                                            #xbox, \
                                                            zha \
                                                            "} \
    \
    HOMEASSISTANT_COMPONENTS_CORE=${HOMEASSISTANT_COMPONENTS_CORE:-" \
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
                                                                    "} \
    HOMEASSISTANT_MODULES_CORE=${HOMEASSISTANT_MODULES_CORE:-" \
                                                                homeassistant.auth.mfa_modules.totp, \
                                                                psycopg2 \
                                                                "} \
    HOMEASSISTANT_USER=${HOMEASSISTANT_USER:-"homeassistant"} \
    HOMEASSISTANT_GROUP=${HOMEASSISTANT_GROUP:-"homeassistant"} \
    GO2RTC_VERSION=${GO2RTC_VERSION:-"v1.9.9"} \
    GOLANG_VERSION=${GOLAND_VERSION:-"1.23.7"} \
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
                        #py3-libcec \
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
                        #python3-dev \
                        #py3-distutils-extra \
                        #py3-parsing \
                        #py3-pip \
                        #py3-setuptools \
                        #py3-wheel \
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
                        #py3-brotli \
                        #py3-mysqlclient \
                        #py3-pip \
                        #py3-psycopg2 \
                        #python3 \
                        zlib-ng \
                    && \
    \
    package install .homeassistant-cli-build-deps \
                        go \
                    && \
    \
    package install .python-build-deps \
                        bluez-dev \
                        bzip2-dev \
                        dpkg-dev dpkg \
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
                        && \
    \
    mkdir -p /usr/src/python && \
    curl -sSL https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz | tar xvfJ - --strip 1 -C /usr/src/python && \
    cd /usr/src/python && \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-lto \
		--with-ensurepip \
        && \
    \
    EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000"; \
    LDFLAGS="${LDFLAGS:--Wl},--strip-all"; \
    case "$(apk --print-arch)" in \
        x86_64|aarch64) \
				EXTRA_CFLAGS="${EXTRA_CFLAGS:-} -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer"; \
        ;; \
        *) \
            # other arches don't support "-mno-omit-leaf"
            EXTRA_CFLAGS="${EXTRA_CFLAGS:-} -fno-omit-frame-pointer"; \
        ;; \
    esac ; \
	make \
             -j $(nproc) \
		"EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" \
		"LDFLAGS=${LDFLAGS:-}" \
	    && \
    \
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
	; \
	\
	find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' \
		| tr ',' '\n' \
		| sort -u \
		| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
		| xargs -rt apk add --no-network --virtual .python-rundeps \
	; \
	package remove \
                    .python-build-deps \
	                && \
	export PYTHONDONTWRITEBYTECODE=1 && \
    \
    for src in idle3 pip3 pydoc3 python3 python3-config; do \
		dst="$(echo "$src" | tr -d 3)"; \
		[ -s "/usr/local/bin/$src" ]; \
		[ ! -e "/usr/local/bin/$dst" ]; \
		ln -svT "$src" "/usr/local/bin/$dst"; \
	done ; \
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
#RUN set -x ; source /assets/functions/00-container && \
    #mkdir -p /opt/homeassistant && \
    #chown -R "${HOMEASSISTANT_USER}":"${HOMEASSISTANT_GROUP}" /opt/homeassistant && \
    #sudo -u "${HOMEASSISTANT_USER}" \
    #    uv venv /opt/homeassistant && \
    ## GCC 14 netifaces (dhcp) module fix
    uv venv /opt/homeassistant && \
    chown -R "${HOMEASSISTANT_USER}":"${HOMEASSISTANT_GROUP}" /opt/homeassistant && \
    source /opt/homeassistant/bin/activate && \
    #mkdir -p /usr/src/netifaces && \
    #curl -sSL https://files.pythonhosted.org/packages/source/n/netifaces/netifaces-0.11.0.tar.gz | tar xvfz - --strip 1 -C /usr/src/netifaces && \
    #curl -sSL https://gitlab.alpinelinux.org/alpine/aports/-/raw/master/community/py3-netifaces/gcc14.patch -o /usr/src/netifaces/gcc.patch && \
    #cd /usr/src/netifaces && \
    #patch -p1 < gcc.patch && \
    uv pip install \
                    setuptools \
                    wheel \
                    && \
    #python3 ./setup.py bdist_wheel && \
    #uv pip install dist/*.whl && \
    uv pip uninstall \
                    setuptools \
                    wheel \
                    && \
    ##
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
    mkdir -p /assets/.changelogs && \
    cp requirements_custom.txt /assets/.changelogs && \
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
    # GO
    mkdir -p /usr/src/golang && \
    curl -sSL https://dl.google.com/go/go${GOLANG_VERSION}.src.tar.gz | tar xvfz - --strip 1 -C /usr/src/golang && \
    cd /usr/src/golang/src/ && \
    ./make.bash 1>/dev/null && \
    export GOROOT=/usr/src/golang/ && \
    export PATH="/usr/src/golang/bin:$PATH" && \
    \
    cd /usr/src && \
    clone_git_repo "${HOMEASSISTANT_CLI_REPO_URL}" "${HOMEASSISTANT_CLI_VERSION}" && \
    /usr/src/golang/bin/go build \
    #go build \
            -ldflags '-s' \
            -o /usr/local/bin/ha-cli \
            && \
    \
    clone_git_repo "${GO2RTC_REPO_URL}" "${GO2RTC_VERSION}" /usr/src/go2rtc && \
    export CGO_ENABLED=0 && \
    /usr/src/golang/bin/go build \
    #go build \
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
