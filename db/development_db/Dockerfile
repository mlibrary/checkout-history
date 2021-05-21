FROM mariadb

ENV MYSQL_USER circulation_history
ENV MYSQL_PASSWORD circulation_history_db_password
ENV MYSQL_DATABASE circulation_history_production
ENV MYSQL_ROOT_PASSWORD pass

COPY database.sql /docker-entrypoint-initdb.d/
#RUN sed -i 's|/var/lib/mysql|/var/lib/mariadb|g' /etc/mysql/my.cnf
#RUN /usr/local/bin/docker-entrypoint.sh mysqld & sleep 30 && killall mysqld
