#!/bin/bash
# Raul Dipeas Repo
echo 'deb https://radix.ws/core-repo cosmic main' > /etc/apt/sources.list.d/rauldipeas.list
echo 'deb https://master.dl.sourceforge.net/project/radix-core/large-repo cosmic main' >> /etc/apt/sources.list.d/rauldipeas.list
curl https://radix.ws/core-repo/rauldipeas.key | gpg --dearmor > /etc/apt/trusted.gpg.d/rauldipeas.gpg
add-apt-repository universe;add-apt-repository multiverse;apt update
apt install -y apt-transport-https build-essential curl gdebi-core libglibmm-2.4-1v5 ruby-dev software-properties-common
# KXStudio Repos
wget -c https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_9.5.1~kxstudio3_all.deb
wget -c https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos-gcc5_9.5.1~kxstudio3_all.deb
gdebi -n kxstudio-repos_9.5.1~kxstudio3_all.deb
gdebi -n kxstudio-repos-gcc5_9.5.1~kxstudio3_all.deb;apt update

# Remoção de pacotes desnecessários
apt autoremove --purge -y\
 apport*\
 at-spi2-core\
 elementary-*\
 gnome-accessibility-themes\
 gnome-themes-standard\
 greybird-gtk-theme\
 gucharmap*\
 humanity-icon-theme\
 imagemagick\
 libgucharmap*\
 libyelp*\
 light-locker\
 lightdm-gtk-greeter\
 numix-gtk-theme\
 plymouth-theme-*\
 spice-vdagent\
 ubuntu-advantage-tools\
 ubuntu-minimal\
 ubuntu-release-upgrader-core\
 ubuntu-standard\
 xfce4-appfinder\
 xfce4-indicator-plugin\
 xfce4-power-manager-plugins\
 xfce4-screenshooter\
 xfce4-statusnotifier-plugin\
 xfce4-terminal\
 xubuntu*\
 yelp*

# Instalação do repositório e das customizações do RaDiX
apt install -y rauldipeas-repo
apt install -y --no-install-recommends ubuntu-software
# Remoção de pacotes desnecessários
apt autoremove --purge -y build-essential fonts-lato meterbridge ruby-dev yelp* libyelp* xfdashboard-plugins
dpkg -l | grep -E linux-image-.*-generic | cut -d ' ' -f3 | grep -v `dpkg -l | grep -E linux-image-.*-generic | cut -d ' ' -f3 | tail -1` | grep -v `uname -r` | xargs apt autoremove --purge -y
# LightDM
echo '[SeatDefaults]
autologin-user=radix
user-session=xfce
greeter-session=lightdm-webkit-greeter' > /etc/lightdm/lightdm.conf
# Natural Scrolling (Converter em Deb)
echo '#!/bin/bash
synclient VertScrollDelta=-58
synclient HorizScrollDelta=-58' > /usr/local/bin/naturalscrolling
chmod +x /usr/local/bin/naturalscrolling
echo '[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=NaturalScrolling
Exec=naturalscrolling
OnlyShowIn=XFCE;
StartupNotify=false
Terminal=false
Hidden=false
Icon=mouse' > /etc/xdg/autostart/NaturalScrolling.desktop
# Gestos do touchpad (Converter em Deb)
git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
./libinput-gestures-setup install;cd ..
rm -rf libinput-gestures*
cp -v /usr/share/applications/libinput-gestures.desktop /etc/xdg/autostart/
echo '
OnlyShowIn=XFCE;' >> /etc/xdg/autostart/libinput-gestures.desktop
echo '
gesture swipe left 3 xdotool key alt+Left
gesture swipe right 3 xdotool key alt+Right
gesture swipe up 4 xfdashboard -t' >> /etc/libinput-gestures.conf
git clone https://gitlab.com/cunidev/gestures
cd gestures; python3 setup.py install;cd ..;rm -rf gestures*
sed -i 's/Icon=org.cunidev.gestures/Icon=libinput-gestures/g' /usr/share/applications/org.cunidev.gestures.desktop
sed -i 's/Name=Gestures/Name=Gestures\nName[pt_BR]=Gestos/g' /usr/share/applications/org.cunidev.gestures.desktop
echo 'StartupWMClass=Gestures' >> /usr/share/applications/org.cunidev.gestures.desktop
# Tecla Super para abrir o Whisker (Converter em Deb)
echo '[Desktop Entry]
Exec=xcape -e "Super_L=Control_L|Escape"
Name=Xcape
Type=Application
OnlyShowIn=XFCE;' > /etc/xdg/autostart/xcape.desktop
# Bash-It/Undistract-Me (Converter em Deb)
echo "[Desktop Entry]
Type=Application
Name=Bash It
Exec=bash /opt/radix-desktop/bash_it.sh
Icon=xterm
StartupNotify=true" > /etc/xdg/autostart/bash_it.desktop
echo "#!/bin/bash
bash ~/.bash_it/install.sh --silent
sed -i 's/bobby/powerline/g' ~/.bashrc
echo '
# Undistract-Me
. /usr/share/undistract-me/long-running.bash
notify_when_long_running_commands_finish_install' >> ~/.bashrc
mkdir ~/.config/autostart
echo 'Hidden=true' > ~/.config/autostart/bash_it.desktop" > /opt/radix-desktop/bash_it.sh
sed -i 's/took/levou/g' /usr/share/undistract-me/long-running.bash
sed -i 's/dialog-information/xterm/g' /usr/share/undistract-me/long-running.bash
sed -i 's/Long\ command\ completed/Comando\ concluído\!/g' /usr/share/undistract-me/long-running.bash