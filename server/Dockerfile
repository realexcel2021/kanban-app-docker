FROM node:20-alpine
WORKDIR /express
COPY . /express/
RUN npm install
EXPOSE 3000
ENTRYPOINT ["node", "app.js"]
