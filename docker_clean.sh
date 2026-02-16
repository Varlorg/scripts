#!/bin/bash

# Docker objects to list
DOCKER_OBJECT="image container network volume"

# Filter to remove only object older than this date
#FILTER_DOCKER='30 days ago'
FILTER_DOCKER="$KEEP_DURATION"

# Disable cleaning
DISABLE_CLEAN=${CLEANING_DISABLED:-true}
# Disable listing
DISABLE_LIST=${LISTING_DISABLED:-false}

###################################################
if [ "${DISABLE_LIST}" != "true" ]; then
	echo "=== Listing ==="
	docker system df

	for o in $DOCKER_OBJECT; do
		docker "$o" ls
	done
fi

###################################################

if [ "${DISABLE_CLEAN}" != "true" ]; then
	echo "=== Cleaning ==="
	FILTER_DOCKER_DATE=$(date --iso-8601 -d "$FILTER_DOCKER")
	#for o in $DOCKER_OBJECT; do
	#  docker $o prune --force --filter "until=$FILTER_DOCKER_DATE"
	#done

	# Stop all old running containers
	docker ps -f status=running --format "{{.ID}} {{.CreatedAt}}" |
		while read -r id cdate ctime _; do
			if [[ $(date +%s -d "$cdate $ctime") -lt $(date +%s -d "$FILTER_DOCKER") ]]; then
				docker kill "$id"
			fi
		done

	docker image prune --all --force --filter "until=$FILTER_DOCKER_DATE"
	docker container prune --force --filter "until=$FILTER_DOCKER_DATE"
	docker network prune --force --filter "until=$FILTER_DOCKER_DATE"
	docker volume prune --force

	#docker system prune --all --force --filter "until=$FILTER_DOCKER_DATE"

fi
###################################################
