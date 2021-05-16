FROM node:14

WORKDIR /usr/src
ADD ./docker/node/runupstream.sh ./runupstream.sh

RUN npm install nodemon -g
# If you are building your code for production
# RUN npm ci --only=production
COPY ./app .
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD ./docker/node/supervisor/ /etc/supervisor/

#CMD [ "nodemon", "--inspect=0.0.0.0", "index.js", "3000" ]
CMD ["sh", "/usr/src/runupstream.sh" ]