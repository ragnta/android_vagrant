sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
sudo apt-get -qq -y install unzip zip
echo "Installing java... (please be patient)"
sudo curl -s "https://get.sdkman.io" | bash
sudo chmod +x "$HOME/.sdkman/bin/sdkman-init.sh"
source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java 8.0.242-amzn
sudo apt-get update
sudo apt-get -y install bzip2 lynx libzip4


export JAVA_HOME=$HOME/.sdkman/candidates/java/8.0.242-amzn

echo "Installing android... (please be patient)"
sudo mkdir -p /android/sdk
sudo chmod 777 /android/sdk
curl -L https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -o sdk-tools-linux.zip &>/dev/null && unzip -q sdk-tools-linux.zip -d /android/sdk/ && rm sdk-tools-linux.zip

sudo yes | /android/sdk/tools/bin/sdkmanager --licenses &>/dev/null

/android/sdk/tools/bin/sdkmanager "platform-tools" "build-tools;27.0.3" "build-tools;28.0.3" "platforms;android-27" "platforms;android-28" &>/dev/null

echo "alias adb=/android/sdk/platform-tools/adb" >> ~/.bashrc

echo "export ANDROID_NDK_PATH=/android/sdk/ndk-bundle" >> ~/.bashrc
echo "export ANDROID_SDK_PATH=/android/sdk/" >> ~/.bashrc
echo "export ANDROID_SDK_ROOT=/android/sdk/" >> ~/.bashrc
echo "export JAVA_HOME=$HOME/.sdkman/candidates/java/8.0.242-amzn" >> ~/.bashrc

git clone https://github.com/creationix/nvm.git ~/.nvm &>/dev/null && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags` &>/dev/null
source ~/.nvm/nvm.sh
printf '\n%s\n' 'LINK_TO_NODE=/usr/bin/nodejs
if test -f "$LINK_TO_NODE"; then
  sudo rm "$LINK_TO_NODE"
fi
sudo ln -s $(whereis node | cut -d " " -f2) /usr/bin/nodejs' >> ~/.bashrc
echo "source ~/.nvm/nvm.sh" >> ~/.bashrc
# install latest stable node.js
echo "Installing node.js... (please be patient)"
nvm install stable &> /dev/null
nvm alias default stable

LINK_TO_NODE=/usr/bin/nodejs
if test -f "$LINK_TO_NODE"; then
  sudo rm "$LINK_TO_NODE"
fi
sudo ln -s $(whereis node | cut -d " " -f2) /usr/bin/nodejs

echo "Installing yarn... (please be patient)"
curl -o- -L https://yarnpkg.com/install.sh 2>/dev/null | bash &> /dev/null

echo "Set watchers... (please be patient)"
echo fs.inotify.max_user_watches=16384 | sudo tee -a /etc/sysctl.conf &>/dev/null
sudo sysctl -p &>/dev/null