#####################################
# Node / NVM:
#####################################

wget https://nodejs.org/dist/v9.11.1/node-v9.11.1-linux-x64.tar.xz
tar xf node-v9.11.1-linux-x64.tar.xz
mv node-v9.11.1-linux-x64 /usr/local/lib/
rm -f node-v9.11.1-linux-x64.tar.xz

mkdir -p /usr/local/lib/node-v9.11.1-linux-x64/etc
echo "prefix=/usr/local" > /usr/local/lib/node-v9.11.1-linux-x64/etc/npmrc

ln -s /usr/local/lib/node-v9.11.1-linux-x64/bin/npx /usr/local/bin/npx
ln -s /usr/local/lib/node-v9.11.1-linux-x64/bin/npm /usr/local/bin/npm
ln -s /usr/local/lib/node-v9.11.1-linux-x64/bin/node /usr/local/bin/node

npm i -g npm
npm i -g gulp bower yarn
npm i -g cross-env
chmod +x /usr/local/lib/node_modules/yarn/bin/yarn.js

mkdir -p /usr/local/lib/node_modules/node-sass
cd /usr/local/lib/node_modules/node-sass && npm i node-sass
rm -rf /root/package* /root/.npm /root/node_modules
