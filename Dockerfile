FROM node:18-alpine as build
WORKDIR /app
COPY --chown=node:node package*.json ./
RUN npm ci
COPY --chown=node:node . .
RUN npm run build
RUN npm ci --only=production && npm cache clean --force
USER node


FROM node:18-alpine As production
WORKDIR /app
COPY --chown=node:node --from=build /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/dist ./dist
EXPOSE 5000
CMD [ "node", "dist/main.js" ]