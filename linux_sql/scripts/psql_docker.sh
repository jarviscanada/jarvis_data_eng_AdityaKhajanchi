#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Check status of docker OR Start Docker ( || is logical operator OR) (Suppressed Output)
sudo systemctl status docker > /dev/null 2>&1  || sudo systemctl start docker

# Check container status and store exit code in variable (Suppressed Output)
docker container inspect jrvs-psql > /dev/null 2>&1
container_status=$?

# User Switch cases to handle create|start|stop operations
case $cmd in

	# To create container
	create)

                # Validate CLI arguments
                if [ $# -ne 3 ]; then
                        echo 'Invalid number of arguments passed.'
                        exit 1
                fi

		# Check if container exists
		if [ "$container_status" -eq 0 ]; then
			echo 'Container already exists.'
			exit 1
		fi
		
		docker volume pgdata
		docker run --name jrvs-psql -e POSTGRES_USER=$db_username -e POSTGRES_PASSWORD=$db_password -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine
		container_status=$?
	;;

	# To start || Stop Container
	start|stop)

		if [ "$container_status" -ne 0 ]; then
                        echo 'Container does not exist. Please create a new container.'
                        exit 1
                fi

		container_running=$(docker inspect -f '{{.State.Running}}' jrvs-psql 2>/dev/null)
		

		if [ "$container_running" = "true" ] && [ "$cmd" = "start" ]; then
			echo "Container already running."
			exit 0
		fi

		if [ "$container_running" = "false" ] && [ "$cmd" = "stop" ]; then
                        echo "Container is already inactive."
                        exit 0
                fi


		docker container $cmd jrvs-psql
		container_status=$?

		if [ "$container_status" -eq 0 ]; then
			echo 'Successful '$cmd''
		else
			echo 'Failed to '$cmd'. Please debug'
		fi

		exit $container_status
	;;

	*)
		echo 'Illegal command'
		echo 'Commands: start|stop|create'
		exit 1
	;;
esac

