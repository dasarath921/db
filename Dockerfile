FROM mysql:8.0

LABEL maintainer="dasarath921" \
      description="MySQL 8.0 with user_management_db schema and seed data" \
      version="1.0"

COPY init.sql /docker-entrypoint-initdb.d/01-init.sql

EXPOSE 3306

HEALTHCHECK --interval=10s --timeout=5s --retries=5 --start-period=30s \
  CMD mysqladmin ping -h localhost -uroot -p$MYSQL_ROOT_PASSWORD || exit 1
