FROM mariadb

ENV MARIADB_USER circulation_history
ENV MARIADB_PASSWORD circulation_history_db_password
ENV MARIADB_DATABASE circulation_history_production
ENV MARIADB_ROOT_PASSWORD pass

COPY all-databases.sql /docker-entrypoint-initdb.d/
