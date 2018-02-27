# Docker PHP-FPM


### Version

> PHP 7.1.14 (cli) (built: Feb 17 2018 00:52:58) ( NTS )


### [PHP Modules]

Enable modules:

- amqp
- apcu
- bcmath
- Core
- ctype
- curl
- date
- dom
- exif
- fileinfo
- filter
- ftp
- gd
- gmp
- hash
- iconv
- imap
- intl
- json
- ldap
- libxml
- mbstring
- mcrypt
- memcached
- mysqlnd
- openssl
- pcntl
- pcre
- PDO
- pdo_mysql
- pdo_pgsql
- pdo_sqlite
- pgsql
- Phar
- posix
- readline
- redis
- Reflection
- session
- SimpleXML
- soap
- sockets
- SPL
- sqlite3
- standard
- swoole
- tokenizer
- xml
- xmlreader
- xmlwriter
- xsl
- Zend OPcache
- zip
- zlib

Disable modules:

- xdebug

```sh
# enable
sed -i 's/^;zend_extension=/zend_extension=/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# disable
sed -i 's/^zend_extension=/;zend_extension=/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
```

### Config


File: `/usr/local/etc/php/conf.d/50-laravel.ini`
```ini
date.timezone=UTC
display_errors=Off
log_errors=On


memory_limit = 128M
; Maximum allowed size for uploaded files.
; http://php.net/upload-max-filesize
upload_max_filesize = 20M
; Sets max size of post data allowed.
; http://php.net/post-max-size
post_max_size = 20M
```

File: `/usr/local/etc/php/conf.d/50-laravel.ini`

```ini
opcache.enable="1"
opcache.memory_consumption="256"
opcache.use_cwd="0"
opcache.max_file_size="0"
opcache.max_accelerated_files = 30000
opcache.validate_timestamps="1"
opcache.revalidate_freq="0"
```


File: `/usr/local/etc/php/conf.d/50-xdebug.ini`
```ini
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.idekey=PHPSTORM

xdebug.remote_autostart=0
xdebug.remote_enable=1
xdebug.cli_color=1
xdebug.profiler_enable=0
xdebug.profiler_output_dir="~/xdebug/phpstorm/tmp/profiling"

xdebug.remote_handler=dbgp
xdebug.remote_mode=req

xdebug.var_display_max_children=-1
xdebug.var_display_max_data=-1
xdebug.var_display_max_depth=-1

```
