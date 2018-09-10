FROM node:8

RUN mkdir /app
ADD webhooker/* /app/
RUN cd /app && npm install

ENTRYPOINT /entrypoint
