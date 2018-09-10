#!/bin/sh

## Create config file

cat << EOF > /app/config.js
exports.settings = {
    rabbitmq: {
        host: "$NOMOS_RABBITMQ_HOST",
        port: "$NOMOS_RABBITMQ_PORT",
        username: "$NOMOS_RABBITMQ_USER",
        password: "$NOMOS_RABBITMQ_PASSWORD",
        vhost: "$NOMOS_RABBITMQ_VHOST"
    },
    nomos: {
        host: "nomos-worker",
        token: "$NOMOS_WEBHOOKER_APIKEY"
    }
};
EOF

cd /app
npm start
