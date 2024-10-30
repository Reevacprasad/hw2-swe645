# Group: Alpha1
# File: Dockerfile
# Description: To create a Docker Image

FROM --platform=linux/amd64 ubuntu:latest 
RUN apt-get update && apt-get install -y nginx
RUN rm /var/www/html/index.nginx-debian.html 
COPY index.html /var/www/html/
COPY j.jpg /var/www/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]