# README
========

## gosu


install-gosu.sh

```bash
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch";

    wget -q --no-check-certificate -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }')"
```

```bash

!#/bin/sh

__install_gosu()
{
    local GOSU_VERSION=1.10
    set -ex; \
    \
    fetchDeps=' \
        ca-certificates \
        wget \
    '; \
    # apt-get update; \
    # apt-get install -y --no-install-recommends $fetchDeps; \
    # rm -rf /var/lib/apt/lists/*; \
    # \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
    chmod +x /usr/local/bin/gosu; \
# verify that the binary works
    gosu nobody true; \
    \
    # apt-get purge -y --auto-remove $fetchDeps
}

# apk add --no-cache su-exec

__install_gosu
```


gosu-worker.sh

```bash
#!/bin/sh

if [ "$(id -u)" != "0" ]; then
    exec "$@"
    exit $?
fi

stat_dir=$(pwd)
uid=$(stat -c '%u' $stat_dir)

exec gosu $uid "$@"
```

```
# Удаляет и диапазонные и IP порты
# sed -e 's/^\(\s\+- \)"[0-9a-z\-\.\:]\+\:\([0-9\-]\+\)"$/\1"\2"/; s/\(\s\+- \)"[0-9a-z\-]\+\:\([0-9\-]\+\)"$/\1"\2"/' ports.yml
# С удалением коментариев
# sed -e 's/^\(\s\+- \)"[0-9a-z\-\.\:]\+\:\([0-9\-]\+\)"$/\1"\2"/; s/\(\s\+- \)"[0-9a-z\-]\+\:\([0-9\-]\+\)"$/\1"\2"/; /^\s*#.\+$/d' ports.yml
```


# Code Style
```
git diff --name-status develop 2>/dev/null | sed '/^[^AMR]/d; /\.php$/!d; s/^.\+\?\s//g; s/^.*$/"&"/;' | tr '\n' ' '

git diff --name-status develop 2>/dev/null | sed '/^[^AMR]/d; /\.php$/!d; s/^.\+\?\s//g; s/^.*$/"&"/;' | tr '\n' ' ' | xargs ecs check --no-progress-bar

```
