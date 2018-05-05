#####################################
# Node / NVM:
#####################################

NODE_VERSION=${NODE_VERSION-9.11.1}

wget "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz"
tar xf "node-v${NODE_VERSION}-linux-x64.tar.xz"
mv "node-v${NODE_VERSION}-linux-x64" /usr/local/lib/
rm -f "node-v${NODE_VERSION}-linux-x64.tar.xz"


NODE_DIR="/usr/local/lib/node-v${NODE_VERSION}-linux-x64"

mkdir -p "${NODE_DIR}/etc"
echo "prefix=/usr/local" > "${NODE_DIR}/etc/npmrc"

ln -s "${NODE_DIR}/bin/npx" /usr/local/bin/npx
ln -s "${NODE_DIR}/bin/npm" /usr/local/bin/npm
ln -s "${NODE_DIR}/bin/node" /usr/local/bin/node

npm i -g npm
npm i -g gulp bower yarn
npm i -g cross-env
chmod +x /usr/local/lib/node_modules/yarn/bin/yarn.js

# mkdir -p /usr/local/lib/node_modules/node-sass
# cd /usr/local/lib/node_modules/node-sass && npm i node-sass
# rm -rf /root/package* /root/.npm /root/node_modules
