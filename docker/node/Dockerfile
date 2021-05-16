FROM node:14

WORKDIR /usr/src
ADD ./docker/node/runupstream.sh ./runupstream.sh
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY ./app/package.json ./
RUN npm install nodemon -g
RUN npm install
# If you are building your code for production
# RUN npm ci --only=production
WORKDIR /usr/src/app
# Bundle app source

COPY ./app .
EXPOSE 3000

RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD ./docker/node/supervisor/ /etc/supervisor/

#CMD [ "nodemon", "--inspect=0.0.0.0", "index.js", "3000" ]
CMD ["sh", "/usr/src/runupstream.sh" ]