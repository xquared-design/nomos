#!/bin/sh

sleep 5

rabbitmq-plugins enable rabbitmq_management
rabbitmqctl add_user $RABBITMQ_ADMIN_USER $RABBITMQ_ADMIN_PASSWORD
rabbitmqctl set_user_tags $RABBITMQ_ADMIN_USER administrator
rabbitmqctl add_user nomos $NOMOS_RABBITMQ_PASSWORD
rabbitmqctl add_user $RABBITMQ_WEBHOOKER_USER $RABBITMQ_WEBHOOKER_PASSWORD
rabbitmqctl add_vhost nomos
rabbitmqctl set_permissions -p nomos vhs ".*" ".*" ".*"
rabbitmqctl set_permissions -p nomos nomos ".*" ".*" ".*"
rabbitmqctl set_permissions -p nomos webhooker "" "" ".*"

# $@ is used to pass arguments to the rabbitmq-server command.
# For example if you use it like this: docker run -d rabbitmq arg1 arg2,
# it will be as you run in the container rabbitmq-server arg1 arg2
rabbitmq-server $@
