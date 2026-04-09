FROM postgres:17

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=mysecretpassword
ENV POSTGRES_DB=psql_db

COPY schema.sql  /docker-entrypoint-initdb.d/01_schema.sql
COPY data.sql    /docker-entrypoint-initdb.d/02_data.sql
COPY queries.sql /docker-entrypoint-initdb.d/03_queries.sql
