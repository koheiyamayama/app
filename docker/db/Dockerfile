FROM mariadb:latest
RUN apt-get update && apt-get install -y locales
RUN locale-gen ja_JP.UTF-8 
ENV LANG ja_JP.UTF-8  
ENV LANGUAGE ja_JP.UTF-8
COPY docker/db/etc/mariadb.cnf /etc/mysql/mariadb.cnf
COPY init_db/ /docker-entrypoint-initdb.d/
