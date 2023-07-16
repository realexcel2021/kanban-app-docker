FROM node:20-alpine
COPY . .
ENV NODE_OPTIONS=--max-old-space-size=4096
RUN npm install
EXPOSE 3000
ENTRYPOINT ["npm", "start"]
