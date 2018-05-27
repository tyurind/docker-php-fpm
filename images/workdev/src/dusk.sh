#!/bin/bash

#####################################
# Dusk Dependencies:
#####################################
CHROME_DRIVER_VERSION=${CHROME_DRIVER_VERSION-2.32}


# ADD commands/xvfb.init.sh /etc/init.d/xvfb

apt-get update -yq \
  && apt-get -yq install zip wget unzip xdg-utils gconf2 \
    libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 xvfb \
    gtk2-engines-pixbuf \
    fonts-ipafont-gothic \
    xfonts-cyrillic xfonts-100dpi xfonts-75dpi \
    xfonts-base xfonts-scalable x11-apps \
    x11vnc \
  && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && dpkg -i --force-depends google-chrome-stable_current_amd64.deb \
  && apt-get -qy -f install \
  && dpkg -i --force-depends google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb \
  && wget -q https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip \
  && unzip chromedriver_linux64.zip \
  && mv chromedriver /usr/local/bin/ \
  && rm chromedriver_linux64.zip

apt-get clean -qy
rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
