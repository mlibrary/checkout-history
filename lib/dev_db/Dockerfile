FROM mariadb

ENV MYSQL_USER circulation_history
ENV MYSQL_PASSWORD circulation_history_db_password
ENV MYSQL_DATABASE circulation_history_production
ENV MYSQL_ROOT_PASSWORD pass

COPY dev_db.sql /docker-entrypoint-initdb.d/
