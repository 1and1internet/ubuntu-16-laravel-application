#!/usr/bin/env bash

if [[ "${WAIT_FOR_DB_MIGRATIONS}" = "false" ]]; then
	exit 0
fi

if [[ -z "${WAIT_FOR_DB_MIGRATIONS}" ]] || [[ "${WAIT_FOR_DB_MIGRATIONS}" = "prompt" ]]; then
	echo "Specify a value for WAIT_FOR_DB_MIGRATIONS if you would like to wait for migrations"
	exit 0
fi

php artisan --no-ansi --no-interaction list | grep migrate:monitor 2>&1 > /dev/null
if [[ $? -ne 0 ]]; then
	echo "Unable to wait for migrations before starting"
	echo "This Laravel Application does not support the artisan command migrate:monitor"
	exit 2
else
	LIMIT=10
	false
	while [[ $? -ne 0 ]]; do
		LIMIT=$[$LIMIT-1]
		if [[ $LIMIT -le 0 ]]; then
			echo "Giving up waiting for database migrations"
			exit 1
		fi
		php artisan --no-ansi --no-interaction migrate:monitor
	done
fi
