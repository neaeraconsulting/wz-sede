# Stage 1: Build the Flutter web application
FROM plugfox/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web --release --base-href /wzam/

# Stage 2: Serve the built application with Nginx
FROM nginx:alpine

# Copy the built app to the /wzam path in nginx
COPY --from=build /app/build/web /usr/share/nginx/html/wzam

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]