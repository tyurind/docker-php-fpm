#
#--------------------------------------------------------------------------
# Postgres client
#--------------------------------------------------------------------------
#
USER root

RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update -yqq && \
    apt-get install -y  --no-install-recommends postgresql-client

# END Postgres client ---------------------------
