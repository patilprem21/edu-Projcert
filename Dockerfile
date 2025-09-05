FROM devopsedu/webapp
COPY index.php /var/www/html/
RUN rm -f /var/www/html/index.html
EXPOSE 80
