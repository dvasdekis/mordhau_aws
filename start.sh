#!/bin/bash

# disable firewall
/usr/bin/sudo ufw disable

# update linux and install dependencies (screen needed for last step)
echo "Updating Linux..."
apt-get -y update
apt-get -y install lib32gcc1 screen tar

# add mord user
useradd -m mord
cd /home/mord
/usr/bin/sudo -u mord curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | /usr/bin/sudo -u mord tar zxvf -

# create update instructions file
/usr/bin/sudo -u mord cat << EOF > /home/mord/update_mordhau.txt
@ShutdownOnFailedCommand 1
@NoPromptForPassword 1
force_install_dir /home/mord/mordhau
app_update 629800 validate
quit
EOF

# create directory for game.ini
/usr/bin/sudo -u mord mkdir -p /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer

# prompt for steam username and password
while [[ -z $steam_username ]]; do
  read -p "Enter Steam username: " steam_username
done

while [[ -z $steam_password || $steam_password != $steam_password_check ]]; do
  if [[ $steam_password != $steam_password_check ]]; then
    echo "Passwords do not match."
    read -s -p "Enter Steam password: "  steam_password
    echo
    read -s -p "Re-enter Steam password: " steam_password_check
    echo
  else
    read -s -p "Enter Steam password: " steam_password
    echo
    read -s -p "Re-enter Steam password: " steam_password_check
    echo
  fi
done

# server name prompt
while [[ -z $server_name ]]; do
  read -p "Enter server name: " server_name
done

# server slots prompt
while [[ -z $server_slots || $server_slots -lt 6 ]]; do
  read -p "Enter server slots (minimum 6): " server_slots
done

# tickrate prompt
while [[ -z $tickrate || $tickrate -lt 30 ]]; do
  read -p "Set tickrate (Default 30): " tickrate
done

# Takes the parameters of steam_username and steam_password
/usr/bin/sudo -u mord /home/mord/steamcmd.sh +login "$steam_username" "$steam_password" +runscript update_mordhau.txt

# unset variables once they're used
unset $steam_username
unset $steam_password
unset $steam_password_check

# cat Game.ini
/usr/bin/sudo -u mord cat << EOF > /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
[/Script/Mordhau.MordhauGameMode]
PlayerRespawnTime=5.000000
BallistaRespawnTime=30.000000
CatapultRespawnTime=30.000000
HorseRespawnTime=30.000000
DamageFactor=1.000000
TeamDamageFactor=0.500000
EOF

# map settings prompts
while true; do
    read -p "Add FL maps to rotation? (y/n) " yn
    case $yn in
        [Yy]* )
        /usr/bin/sudo -u mord echo "MapRotation=FL_Taiga" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=FL_MountainPeak" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=FL_Camp" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=FL_Grad" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        ;;
        * ) break;;
    esac
done

while true; do
    read -p "Add HRD maps to rotation? (y/n) " yn
    case $yn in
        [Yy]* )
        /usr/bin/sudo -u mord echo "MapRotation=HRD_Taiga" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=HRD_MountainPeak" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=HRD_Camp" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=HRD_Grad" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        ;;
        * ) break;;
    esac
done

while true; do
    read -p "Add BR maps to rotation? (y/n) " yn
    case $yn in
        [Yy]* )
        /usr/bin/sudo -u mord echo "MapRotation=BR_Taiga" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=BR_Grad" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        ;;
        * ) break;;
    esac
done

while true; do
    read -p "Add SKM maps to rotation? (y/n) " yn
    case $yn in
        [Yy]* )
        /usr/bin/sudo -u mord echo "MapRotation=SKM_Grad" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=SKM_MountainPeak" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=SKM_Camp" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=SKM_Tourney" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=SKM_ThePit" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=SKM_Contraband" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=SKM_Taiga" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        ;;
        * ) break;;
    esac
done

while true; do
    read -p "Add FFA maps to rotation? (y/n) " yn
    case $yn in
        [Yy]* )
        /usr/bin/sudo -u mord echo "MapRotation=FFA_Grad" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=FFA_MountainPeak" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=FFA_Camp" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=FFA_Tourney" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=FFA_ThePit" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=FFA_Contraband" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=FFA_Taiga" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        ;;
        * ) break;;
    esac
done

while true; do
    read -p "Add TDM maps to rotation? (y/n) " yn
    case $yn in
        [Yy]* )
        /usr/bin/sudo -u mord echo "MapRotation=TDM_Grad" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=TDM_MountainPeak" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=TDM_Camp" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=TDM_Tourney" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=TDM_ThePit" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=TDM_Contraband" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        /usr/bin/sudo -u mord echo "MapRotation=TDM_Taiga" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        ;;
        * ) break;;
    esac
done

sudo -u mord cat << EOF >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
[/Script/Mordhau.MordhauGameSession]
ServerPassword=
AdminPassword=
BannedPlayers=()
EOF

# set admins
while true; do
    read -p "Do you wish to nominate additional server admins? (y/n) " yn
    case $yn in
        [Yy]* )
        read -p "Enter admin SteamID: " add_admin
        echo "Admins=$add_admin" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
        ;;
        * ) echo "Admins=" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini; break;;
    esac
done

# set maxslots
/usr/bin/sudo -u mord echo "MaxSlots=$server_slots" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini

# set default map
echo "Available maps: "
echo
echo "Grad (All modes)"
echo
echo "Taiga (All modes)"
echo
echo "MountainPeak (HRD/FL/TDM/FFA/SKM only)"
echo
echo "Camp (HRD/FL/TDM/FFA/SKM only)"
echo
echo "Contraband (TDM/FFA/SKM only)"
echo
echo "ThePit (TDM/FFA/SKM only)"
echo
echo "Tourney (TDM/FFA/SKM only)"
echo

while [[ -z $map1_mode ]]; do
  read -p "Specify initial map mode (default FFA): " map1_mode
done

while [[ -z $map1 ]]; do
  read -p "Specify initial map (default ThePit): " map1
done

chmod chmod a+w /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Engine.ini # in case script is re-run
/usr/bin/sudo -u mord cat << EOF > /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Engine.ini
[/Script/EngineSettings.GameMapsSettings]
ServerDefaultMap=/Game/Mordhau/Maps/`$map1`Map/`$map1_mode`_`$map1`.`$map1_mode`_`$map1`
EOF

# set tickrate and append to server name if greater than default
if [[ $tickrate -gt 30 ]]; then
  /usr/bin/sudo -u mord echo "[/Script/OnlineSubsystemUtils.IpNetDriver]" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Engine.ini
  /usr/bin/sudo -u mord echo "NetServerMaxTickRate=$tickrate" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Engine.ini
  /usr/bin/sudo -u mord echo "ServerName=$server_name ($tickrate tickrate)" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
else
  /usr/bin/sudo -u mord echo "ServerName=$server_name" >> /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
fi

chmod -R a+rwx /home/mord
chmod a=rx /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Engine.ini # seems to get cleared otherwise
/usr/bin/sudo -u mord screen -dmS mordhau /home/mord/mordhau/MordhauServer.sh
echo "Process started & screen detached, run 'sudo -u mord screen -r' to reattach."
