FROM node:20-alpine as builder
WORKDIR /app
COPY . /app
RUN npm install --force
RUN npm run build


FROM nginx:alpine3.17-slim
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
