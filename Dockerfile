FROM nginx:alpine
ARG BUILD_NUMBER=0
COPY app/ /usr/share/nginx/html/
RUN echo "Build ${BUILD_NUMBER}" > /usr/share/nginx/html/version.txt
