#!/bin/bash

groupadd -g 1000 workuser
useradd -u 1000 -g workuser -m workuser
mkdir -p /home/workuser
usermod -a -G sudo workuser
usermod -s /bin/bash workuser

cp /etc/aliases.sh /home/workuser/aliases.sh
touch  /home/workuser/.bashrc

echo "" >> /home/workuser/.bashrc
echo "# Load Custom Aliases" >> /home/workuser/.bashrc
echo "source /home/workuser/aliases.sh" >> /home/workuser/.bashrc
echo "" >> /home/workuser/.bashrc

chown -R workuser:workuser /home/workuser

echo "" >> /etc/sudoers
echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers
echo 'workuser:secret' | chpasswd
