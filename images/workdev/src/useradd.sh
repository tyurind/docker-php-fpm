#!/bin/bash

PUID=${PUID-1000}
PGID=${PGID-1000}
WORKUSER=${WORKUSER-workuser}
WORKUSER_HOME=/home/workuser

groupadd -g "${PGID}" "${WORKUSER}"
useradd -u "${PUID}" -g "${WORKUSER}" -m "${WORKUSER}"
mkdir -p "${WORKUSER_HOME}"

usermod -a -G sudo "${WORKUSER}"
usermod -s /bin/bash "${WORKUSER}"

cp /etc/aliases.sh "${WORKUSER_HOME}/aliases.sh"
touch  "${WORKUSER_HOME}/.bashrc"

echo "" >> "${WORKUSER_HOME}/.bashrc"
echo "# Load Custom Aliases" >> "${WORKUSER_HOME}/.bashrc"
echo "source ${WORKUSER_HOME}/aliases.sh" >> "${WORKUSER_HOME}/.bashrc"
echo "" >> "${WORKUSER_HOME}/.bashrc"

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
    chown -R workuser:workuser "${WORKUSER_HOME}/.ssh"
fi

rm -rf "${WORKUSER_HOME}/.composer"
rm -rf /root/.composer/cache
mv /root/.composer "${WORKUSER_HOME}/"

# chown -R workuser:workuser /home/workuser/.composer
chown -R ${WORKUSER}:${WORKUSER} "${WORKUSER_HOME}"
