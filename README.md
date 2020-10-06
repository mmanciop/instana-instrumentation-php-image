# Instana Instrumentation Image for PHP

This project gives you an easy way to bring the Instana PHP Extension into Docker images.

## Build

```sh
docker build . --build-arg "php_version=<PHP_VERSION>" --build-arg "download_key=<DOWNLOAD_KEY>" --build-arg "extension=<EXTENSION>" -t instana-php-instrumentation
```

Valid values for the required `php_version` build param:

- `5.3`, `5.4`, `5.5` and `5.6`
- `7.0`, `7.1`, `7.2`, `7.3` and `7.4`

The value for `download_key` is the agent key you can use to download.

Valid values for the optional `extension` build param:

- `-alpine`
- `-alpine-debug`
- `-debug`
- `-zts`
- `-zts-alpine-debug`
- `-zts-debug`

## Outcome

The `instana-php-instrumentation` image will have a pretty straightforward content:

```sh
  └── opt
      └── instana
          └── instrumentation
              └── php
                  └── instana.so
```

You can then use this image in a Docker multi-step build and _victory_.
