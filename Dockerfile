FROM postgres:18

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=mysecretpassword
ENV POSTGRES_DB=psql_db

COPY schema.sql  /tmp/schema.sql
COPY data.sql    /tmp/data.sql
COPY queries.sql /tmp/queries.sql
