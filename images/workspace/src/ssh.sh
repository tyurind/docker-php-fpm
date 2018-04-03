#####################################
# ssh:
#####################################
mkdir -p /root/.ssh

# if [ ${INSTALL_WORKSPACE_SSH} = true ]; then \
    rm -f /etc/service/sshd/down \
    && /usr/sbin/enable_insecure_key \
    && /etc/my_init.d/00_regen_ssh_host_keys.sh \
    ### && touch /etc/service/sshd/down \
    # && cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
    #     && cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub \
    #     && cat /tmp/id_rsa >> /root/.ssh/id_rsa \
    #     && rm -f /tmp/id_rsa* \
    #     && chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
    # && chmod 400 /root/.ssh/id_rsa \
    # && cp -r /root/.ssh /home/workuser/.ssh \
    # && chown -R workuser:workuser /home/workuser/.ssh \
# ;fi


if [ -e /tmp/id_rsa.pub ]; then
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys
    cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub
    cat /tmp/id_rsa >> /root/.ssh/id_rsa
    chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub
    chmod 400 /root/.ssh/id_rsa
fi

if [ -d "/home/workuser" ]; then
    cp -r /root/.ssh /home/workuser/.ssh
    chown -R workuser:workuser /home/workuser/.ssh
fi


echo "No SSH host key available. Generating one..."
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
dpkg-reconfigure openssh-server


# RUN /usr/sbin/init-user-work.sh www-data 2>/dev/null
echo "" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config \
    && echo "UsePAM yes" >> /etc/ssh/sshd_config \
    && echo "" >> /etc/ssh/sshd_config

#####################################

apt-get clean -qy
rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
