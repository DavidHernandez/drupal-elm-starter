#!/usr/bin/env bash

# Load helper functionality.
source helper_functions.sh

# Check the current build.
if [ -z ${BUILD_WEBDRIVERIO+x} ] || [ "$BUILD_WEBDRIVERIO" -ne 1 ]; then
 exit 0;
fi

# Update JAVA version
cd /opt/
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz"
tar xzf jdk-7u79-linux-x64.tar.gz

# Install Firefox (iceweasel).
echo -e "\n${BGCYAN}[RUN] Install firefox. ${RESTORE}"
apt-get update
apt-get -qq -y install iceweasel > /dev/null

# Install headless GUI for browser.'Xvfb is a display server that performs graphical operations in memory'
echo -e "\n [RUN] Installing XVFB (headless GUI for Firefox).\n"
apt-get install xvfb -y
apt-get install openjdk-7-jre-headless -y
Xvfb :99 -ac &
export DISPLAY=:99
sleep 5

# Install Selenium.
echo -e  "\n${BGCYAN}[RUN] Install Selenium. ${RESTORE}"
wget http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.0.jar
java -jar selenium-server-standalone-2.53.0.jar > /dev/null 2>&1 &

# Install global packages.
npm install -g elm@~0.18.0
npm install -g elm-test
npm install -g bower
npm install -g gulp

cd $ROOT_DIR/client
npm install
bower install

elm-package install -y

# Getting elm-make to run quicker.
# See https://github.com/elm-lang/elm-compiler/issues/1473#issuecomment-245704142
if [ ! -d sysconfcpus/bin ];
then
  git clone https://github.com/obmarg/libsysconfcpus.git;
  cd libsysconfcpus;
  ./configure --prefix=$ROOT_DIR/sysconfcpus;
  make && make install;
  pwd
  cd ..;
fi

# Run gulp in the background.
gulp &
