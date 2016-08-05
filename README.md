# Laravel 5 Application Base on Ubuntu 16 PHP 7.0

**_Current Status: Work In Progress_**

A Docker image to use as a basis for Docker contained Laravel 5 applications based on PHP 7.0, which will be running under OpenShift.

* Laravel is a PHP based web application framework: https://laravel.com/
* PHP is a scripting language for web development: http://php.net/
* OpenShift is a container application platform based on Docker: https://www.openshift.org/
* Docker is an software containerization tool: https://www.docker.com/

## Usage

## Creating your own application image

 1. Create a Dockerfile in your project folder
	```
	FROM astrolox/ubuntu-16-laravel-application
	COPY src/ ./
	RUN \
		composer install \
			--no-ansi \
			--no-dev \
			--no-interaction \
			--no-progress \
			--prefer-dist && \
		php artisan optimize && \
		application-set-file-permissions
	```
 2. Place your laravel application code in ./src/
	```
	composer create-project --prefer-dist laravel/laravel ./src/
	```
 3. Build your docker image
	```
	docker build -t mylaravelapp .
	```
 4. See it running
	```
	docker run -d -P mylaravelapp
	```

For configuring passwords, etc, I recommend environment variables via the --env-file paramter to docker run. Please see the Docker documentation for further details.

## Deploying to OpenShift

Modify the Image names in the openshift-template.yaml.
```
oc new-app --file=openshift-template.yaml --param=APP_HOSTNAME_SUFFIX=.laravelapp.example.com
```

## Environment variables

All configuration is via environment variables.

* Just OpenShift
  * ``APP_NAME`` - Name of this Laravel application (maximum 17 characters)
  * ``APP_DB_DATABASE`` - Database database name
  * ``APP_HOSTNAME_SUFFIX`` - HTTPS hostname suffix for the routes

* Both Docker and OpenShift
  * ``APP_WORKER_QUEUES`` - defaults to high,low
  * ``APP_WORKER_TIMEOUT`` - defaults to 180
