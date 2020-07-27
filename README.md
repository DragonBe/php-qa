# PHP QA Containers

These are PHP containers from the official [PHP Docker images](https://hub.docker.com/_/php) configured with most common extensions so they can be used directly for improving quality in PHP applications.

## Requirements

These containers have most common PHP extensions installed (compared to the official images), but are not build with QA tools themselves. Your codebase should have them available as composer packages or `*.phar` artefacts.

## Usage

Launch these containers immediately from your workstation or CI platform:

```shell
docker run --rm -ti -v "$PWD":/var/run/phpapp -w /var/run/phpapp dragonbe/php-qa ./vendor/bin/phpunit
```

## License

This code is provided under [MIT License](LICENSE.md).
