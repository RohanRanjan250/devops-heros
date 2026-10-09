FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
# fix (Trivy): nginx:1.27-alpine (Alpine 3.21.3) had 45 fixable HIGH/CRITICAL CVEs
FROM nginx:1.30-alpine
# pick up Alpine security patches released after the base image was built
RUN apk upgrade --no-cache
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
