# README
========

Skeep static ssh

```
touch /etc/service/sshd/down
```

Skeep static ssh

```
touch /etc/service/sshd/down
```

Skeep auto usermod
```
touch /etc/workuser.lock
```


```yml
version: '2'

services:

### Workspace Utilities ##################################
  dev:
    image: fobia/php-fpm:workdev
    environment:
      #PHP_IDE_CONFIG: "serverName=localhost"
      PHP_INSTALL_XDEBUG: "false"
      WORKUSER_PASSWORD: "workuser"
    extra_hosts:
      - "dockerhost:10.0.75.1"
    ports:
      - "2222:22"
    tty: true
    privileged: true
    volumes:
      - ./:/var/www
```
