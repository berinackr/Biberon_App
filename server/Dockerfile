FROM node:20-alpine As dev

# Add necessary packages
RUN apk add --no-cache bash
RUN npm i -g @nestjs/cli typescript ts-node

# A wildcard is used to ensure both package.json AND package-lock.json are copied
WORKDIR /app

ENV NODE_ENV development

RUN getent group node || addgroup --system --gid 1001 node
RUN  id -u node &>/dev/null || adduser --system --uid 1001 node

# Install app dependencies
COPY --chown=node:node package*.json ./
RUN npm ci

# Bundle app source
COPY --chown=node:node . .
COPY /scripts/wait-for-it.sh /opt/wait-for-it.sh
RUN chmod +x /opt/wait-for-it.sh
COPY /scripts/startup.relational.dev.sh /opt/startup.relational.dev.sh
RUN chmod +x /opt/startup.relational.dev.sh
RUN sed -i 's/\r//g' /opt/wait-for-it.sh
RUN sed -i 's/\r//g' /opt/startup.relational.dev.sh

# # generate prisma types
# RUN npx prisma generate

# change ownership of all files to the node user
RUN find . -path ./node_modules -prune -o -exec chown node:node {} \;

USER node


FROM node:20-alpine as build
WORKDIR /app

RUN apk add --no-cache bash
RUN npm i -g @nestjs/cli typescript ts-node

ENV NODE_ENV development

RUN getent group node || addgroup --system --gid 1001 node
RUN  id -u node &>/dev/null || adduser --system --uid 1001 node

COPY --chown=node:node --from=dev /app/node_modules ./node_modules
COPY --chown=node:node --from=dev /opt /opt


COPY --chown=node:node . .
COPY /scripts/startup.relational.sh /opt/startup.relational.sh
RUN chmod +x /opt/startup.relational.sh
RUN sed -i 's/\r//g' /opt/startup.relational.sh

RUN npm run build
RUN npm prune --omit=dev

USER node

FROM node:20-alpine as prod

WORKDIR /app

RUN apk add --no-cache bash

ENV NODE_ENV development

RUN getent group node || addgroup --system --gid 1001 node
RUN  id -u node &>/dev/null || adduser --system --uid 1001 node

COPY --chown=node:node --from=build /app/dist dist
COPY --chown=node:node --from=build /app/node_modules node_modules
COPY --chown=node:node --from=build /opt /opt
COPY --chown=node:node --from=build /app/prisma prisma
COPY --chown=node:node --from=build /app/package*.json ./
RUN find . -path ./node_modules -prune -o -exec chown node:node {} \;

USER node

CMD ["/opt/startup.relational.sh"]
