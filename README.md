# ubuntu-16-laravel-application

**_Current Status: Work In Progress_**

A Docker image to use as a basis for Docker contained Laravel 5 applications based on PHP 7.0, which will be running under OpenShift.

* Laravel is a PHP based web application framework: https://laravel.com/
* PHP is a scripting language for web development: http://php.net/
* OpenShift is a container application platform based on Docker: https://www.openshift.org/
* Docker is an software containerization tool: https://www.docker.com/

## Quick Start

### Using OpenShift

```
oc new-app --file=openshift-template.yaml --param=APP_HOSTNAME_SUFFIX=.laravelapp.example.com
```

### Using Docker

```
docker run -d -P --link rabbitmq:rabbitmq --name=laravelapp astrolox/ubuntu-16-laravel-application
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
