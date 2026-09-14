#STAGE 1: Build React App

FROM node:18-alpine AS Build 
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY react-app/ .
RUN npm run build

#STAGE 2: Serve React App with Nginx
FROM nginx:alpine
COPY --from=Build /app/build /usr/share/nginx/html