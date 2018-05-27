#!/bin/bash

PUID=${PUID-1000}
PGID=${PGID-1000}
WORKUSER=${WORKUSER-workuser}

groupadd -g "${PGID}" "${WORKUSER}"
useradd -u "${PUID}" -g "${WORKUSER}" -m "${WORKUSER}"

WORKUSER_HOME=$(grep -P "^${WORKUSER}:" /etc/passwd | cut -d":" -f 6)

usermod -a -G sudo "${WORKUSER}"
usermod -a -G docker_env "${WORKUSER}"
usermod -s /bin/bash "${WORKUSER}"

#chgrp -R docker_env /etc/container_environment
#chmod g+rxw   /etc/container_environment
#chmod -R g+rw /etc/container_environment
#chmod g+rw /etc/container_environment.sh
#chmod g+rw /etc/container_environment.json

echo "" >> "/root/.bashrc"
echo 'export PATH="vendor/bin:/var/www:/var/www/vendor/bin:~/bin:$PATH"' >> "/root/.bashrc"

cat >> "/root/.bashrc"  <<'EOF'

if [ "${PHP_IDE_CONFIG}" != "" ]; then
    PS1='\[\e]0;[${PHP_IDE_CONFIG}]\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}[${PHP_IDE_CONFIG}]\u@\h:\w\$ '
fi

EOF

cp /root/.bashrc "${WORKUSER_HOME}/.bashrc"

sed -i 's/^%sudo.\+/%sudo   ALL=(ALL) NOPASSWD:ALL/' /etc/sudoers
echo "${WORKUSER}:${WORKUSER}" | chpasswd


# =====================================
if [ -d "${WORKUSER_HOME}" ]; then
    cp -r /root/.ssh "${WORKUSER_HOME}/.ssh"
fi
if [ -f /root/.bash_aliases ]; then
    cp /root/.bash_aliases "${WORKUSER_HOME}/"
fi

rm -rf "${WORKUSER_HOME}/.composer"
cp -r /root/.composer "${WORKUSER_HOME}/"

chown -R ${WORKUSER}:${WORKUSER} "${WORKUSER_HOME}"

