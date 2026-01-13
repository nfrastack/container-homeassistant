# nfrastack/container-homeassistant

## About

This will build a container image for [Home Assistant](https://home-assistant.io), an automation platform.

This is a customized build with a very small amount of components and modules included to keep image size down and to be used specifically for my own installations. Of course you can use it for your own as well.

## Maintainer

- [Nfrastack](https://www.nfrastack.com)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Prebuilt Images](#prebuilt-images)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
- [Environment Variables](#environment-variables)
  - [Base Images used](#base-images-used)
  - [Core Configuration](#core-configuration)
- [Users and Groups](#users-and-groups)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support & Maintenance](#support--maintenance)
- [License](#license)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-homeassistant/pkgs/container/container-homeassistant) and [Docker Hub](https://hub.docker.com/r/nfrastack/homeassistant).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-homeassistant:(image_tag)
docker.io/nfrastack/homeassistant:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>-<optional_distribution>_<optional_distribution_variant>`

Example:

`ghcr.io/nfrastack/container-homeassistant:latest` or

`ghcr.io/nfrastack/container-homeassistant:1.0` or optionally

`ghcr.io/nfrastack/container-homeassistant:1.0-alpine` or optinally

`ghcr.io/nfrastack/container-homeassistant:alpine`

- `latest` will be the most recent commit
- An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest
- If it is built for multiple distributions there may exist a value of `alpine` or `debian`
- If there are multiple distribution variations it may include a version - see the registry for availability

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

- The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

- Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
- Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory  | Description          |
| ---------- | -------------------- |
| `/config/` | Configuration folder |
| `/logs`    | Logs                 |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description           |
| ------------------------------------------------------- | --------------------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image            |
| [Nginx](https://github.com/nfrastack/container-nginx/)  | Web Server Base Image |

Below is the complete list of available options that can be used to customize your installation.

- Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Container Options

| Variable              | Value                                                           | Default             | _FILE |
| --------------------- | --------------------------------------------------------------- | ------------------- | ----- |
| `CONFIG_PATH`         | Configuration directory                                         | `/config/`          |       |
| `ENABLE_NGINX`        | Enable Nginx Frontend webserver                                 | `TRUE`              |       |
| `ENABLE_BUILD_TOOLS`  | Install development tools if having problems installing modules | `FALSE`             |       |
| `ENABLE_MIMALLOC`     | Enable high performance  memory allocator                       | `TRUE`              |       |
| `HOMEASSISTANT_MODE`  | Home Assistant Mode                                             | `NORMAL`            |       |
| `HOMEASSISTANT_USER`  | Home Assistant User                                             | `homeassistant`     |       |
| `HOMEASSISTANT_GROUP` | Home Assistant Group                                            | `homeassistant`     |       |
| `LISTEN_PORT`         | Listening Port                                                  | `8123`              |       |
| `LOG_PATH`            | Log Path                                                        | `/logs/`            |       |
| `LOG_FILE`            | Log File                                                        | `homeassistant.log` |       |
| `SKIP_PIP`            | Skip using PIP on Home Assistant startup                        | `FALSE`             |       |

### Soon

| Variable   | Value                          | Default | _FILE |
| ---------- | ------------------------------ | ------- | ----- |
| `LOG_TYPE` | `console` `file` `both` `none` | `FILE`  |       |

## Users and Groups

| Type  | Name            | ID     |
| ----- | --------------- | ------ |
| User  | `homeassistant` | `4663` |
| Group | `homeassistant` | `4663` |

### Networking

| Port   | Protocol | Description                 |
| ------ | -------- | --------------------------- |
| Port   | Protocol | Description                 |
| ------ | -------- | --------------------------- |
| `80`   | `tcp`    | Nginx                       |
| `8123` | `tcp`    | Home Assistant Web Interace |


* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

## Support & Maintenance

- For community help, tips, and community discussions, visit the [Discussions board](/discussions).
- For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
- To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
- Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
- Updates are best-effort, with priority given to active production use and support agreements.

## References

* <https://home-assistant.io>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
