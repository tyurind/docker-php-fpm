export USER_NAME=workuser
export NODE_VERSION=${NODE_VERSION-9.10.1}
export NVM_DIR="/home/${USER_NAME}/.nvm"

addbashrc()
{
    echo "$@" >> /tmp/bashrc.sh
    return 0

    echo "$@" >> "/home/${USER_NAME}/.bashrc"
    echo "$@" >> /root/.bashrc
}

#####################################
# Node /
#####################################

install_node()
{
    cat > /tmp/install.sh <<EOF

export USER_NAME=workuser
export NODE_VERSION=${NODE_VERSION-9.10.1}
export NVM_DIR="/home/${USER_NAME}/.nvm"

    curl -o- /tmp/install.sh https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash && \
        . $NVM_DIR/nvm.sh && \
        nvm install ${NODE_VERSION} && \
        nvm use ${NODE_VERSION} && \
        nvm alias ${NODE_VERSION} && \
        npm install -g yarn gulp bower grunt webpack vue-cli
EOF
    cd /tmp && sudo -u workuser bash /tmp/install.sh
    rm /tmp/install.sh
}

# Install nvm (A Node Version Manager)
install_node

echo "" > /tmp/bashrc.sh
addbashrc "" && \
addbashrc "export NVM_DIR=${NVM_DIR}" && \
addbashrc '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm'

cat /tmp/bashrc.sh >> /root/.bashrc
cat /tmp/bashrc.sh >> "/home/${USER_NAME}/.bashrc"
rm -f /tmp/bashrc.sh
