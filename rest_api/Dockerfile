FROM node:14.4.0-stretch

RUN mkdir -p /home/node/app && chown -R node:node /home/node/app
WORKDIR /home/node/app
RUN  rm -rf  package-lock.json  || true
COPY package.json  ./
COPY server.js ./
COPY src  ./src
RUN  npm install  --no-optional && npm cache clean --force
EXPOSE 3000

CMD [ "npm","run","start" ]