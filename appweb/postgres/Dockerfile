FROM postgres:10

# Custom row
ARG PGDATA=""
ENV PGDATA ${PGDATA}

RUN if [ ${PGDATA} != "" ]; then \
    mkdir -p "$PGDATA" && \
    # chmod -R u=rwx "$PGDATA" \
    chmod -R o+rw "$PGDATA" \
    # && chown -R postgres "$PGDATA" \
;fi

RUN touch /usr/local/src/dropdb.sql && \
    echo "" > /usr/local/src/dropdb.sql && \
    echo "DROP DATABASE IF EXISTS wellmax;"  >> /usr/local/src/dropdb.sql && \
    echo "" >> /usr/local/src/dropdb.sql && \
    echo "CREATE DATABASE wellmax;"  >> /usr/local/src/dropdb.sql && \
    echo "" >> /usr/local/src/dropdb.sql


CMD ["postgres"]

EXPOSE 5432
