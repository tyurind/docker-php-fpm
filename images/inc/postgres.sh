# USER root
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
apt-get update -y && apt-get install -y lsb-release

# UBUNTU
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
apt-get update -yq && apt-get install -y postgresql-client


# Debian 9 (Stretch)
# sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
# Debian 8 (Jessie)
# sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
# Debian 7 (Wheezy)
# sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

# apt-get update
# apt-get install postgresql postgresql-contrib


# for pgadmin
# /var/www/html/phpPgAdmin/conf/config.inc.php
# $conf['extra_login_security'] = false;