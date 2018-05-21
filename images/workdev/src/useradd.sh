#!/bin/bash

PUID=${PUID-1000}
PGID=${PGID-1000}
WORKUSER=${WORKUSER-workuser}

groupadd -g "${PGID}" "${WORKUSER}"
useradd -u "${PUID}" -g "${WORKUSER}" -m "${WORKUSER}"

WORKUSER_HOME=$(grep -P "^${WORKUSER}:" /etc/passwd | cut -d":" -f 6)

usermod -a -G sudo "${WORKUSER}"
usermod -s /bin/bash "${WORKUSER}"

# cp /etc/aliases.sh "${WORKUSER_HOME}/aliases.sh"
# touch  "${WORKUSER_HOME}/.bashrc"


echo "" >> "/root/.bashrc"
echo 'export PATH="vendor/bin:/var/www:/var/www/vendor/bin:$PATH"' >> "/root/.bashrc"

#echo "" >> "${WORKUSER_HOME}/.bashrc"
#echo 'export PATH="vendor/bin:/var/www:/var/www/vendor/bin:$PATH"' >> "${WORKUSER_HOME}/.bashrc"

cat >> "/root/.bashrc"  <<'EO'

if [ "${PHP_IDE_CONFIG}" != "" ]; then
    PS1='\[\e]0;[${PHP_IDE_CONFIG}]\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}[${PHP_IDE_CONFIG}]\u@\h:\w\$'
fi

EO

cp /root/.bashrc "${WORKUSER_HOME}/.bashrc"


# echo "" >> "${WORKUSER_HOME}/.bashrc"
# echo "# Load Custom Aliases" >> "${WORKUSER_HOME}/.bashrc"
# echo "source ${WORKUSER_HOME}/aliases.sh" >> "${WORKUSER_HOME}/.bashrc"
# echo "" >> "${WORKUSER_HOME}/.bashrc"

# mkdir "${WORKUSER_HOME}/.composer"
# if [ -f "/usr/local/etc/src/composer.json" ]; then
#     cp /usr/local/etc/src/composer.json "${WORKUSER_HOME}/.composer/composer.json"
# fi

# chown -R ${WORKUSER}:${WORKUSER} "${WORKUSER_HOME}"
# chown -R workuser:workuser "${WORKUSER_HOME}"

# echo "" >> /etc/sudoers
# echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers
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
