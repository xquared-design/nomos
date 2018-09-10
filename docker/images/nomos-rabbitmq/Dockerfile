FROM rabbitmq:3.6-management

ADD docker/images/nomos-rabbitmq/init.sh /init.sh

EXPOSE 15672

# Override the argument for the upstream image ENTRYPOINT
CMD ["/init.sh"]
