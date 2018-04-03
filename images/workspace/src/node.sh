#####################################
# Node / NVM:
#####################################

wget https://nodejs.org/dist/v9.10.1/node-v9.10.1-linux-x64.tar.xz
tar xf node-v9.10.1-linux-x64.tar.xz
mv node-v9.10.1-linux-x64 /usr/local/lib/
rm -f node-v9.10.1-linux-x64.tar.xz

mkdir -p /usr/local/lib/node-v9.10.1-linux-x64/etc
echo "prefix=/usr/local" > /usr/local/lib/node-v9.10.1-linux-x64/etc/npmrc

ln -s /usr/local/lib/node-v9.10.1-linux-x64/bin/npx /usr/local/bin/npx
ln -s /usr/local/lib/node-v9.10.1-linux-x64/bin/npm /usr/local/bin/npm
ln -s /usr/local/lib/node-v9.10.1-linux-x64/bin/node /usr/local/bin/node

npm i -g gulp bower yarn
