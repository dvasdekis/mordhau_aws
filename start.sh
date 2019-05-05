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

# ALL USER PROMPTS GO HERE
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

# END USER PROMPTS (except admins)

# Takes the parameters of steam_username and steam_password
/usr/bin/sudo -u mord /home/mord/steamcmd.sh +login "$steam_username" "$steam_password" +runscript update_mordhau.txt

# unset variables once they're used
unset $steam_username
unset $steam_password
unset $steam_password_check

# Edit the below to set server configuration - get admin steam ids from steamid.io
/usr/bin/sudo -u mord cat << EOF > /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini
[/Script/Mordhau.MordhauGameMode]
PlayerRespawnTime=5.000000
BallistaRespawnTime=30.000000
CatapultRespawnTime=30.000000
HorseRespawnTime=30.000000
DamageFactor=1.000000
TeamDamageFactor=0.500000
MapRotation=FL_Taiga
MapRotation=FL_MountainPeak
MapRotation=FL_Camp
MapRotation=FL_Grad

[/Script/Mordhau.MordhauGameSession]
ServerPassword=
AdminPassword=
BannedPlayers=()
EOF

# Removed maps
# MapRotation=SKM_Grad
# MapRotation=SKM_MountainPeak
# MapRotation=SKM_Camp
# MapRotation=SKM_Tourney
# MapRotation=SKM_ThePit
# MapRotation=SKM_Contraband
# MapRotation=SKM_Taiga
# MapRotation=FFA_ThePit
# MapRotation=TDM_Camp
# MapRotation=FFA_Contraband
# MapRotation=TDM_Tourney
# MapRotation=FFA_Taiga
# MapRotation=TDM_ThePit
# MapRotation=FFA_Grad
# MapRotation=TDM_Contraband
# MapRotation=FFA_MountainPeak
# MapRotation=TDM_Taiga
# MapRotation=FFA_Camp
# MapRotation=TDM_Grad
# MapRotation=FFA_Tourney
# MapRotation=TDM_MountainPeak

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
/usr/bin/sudo -u mord cat << EOF > /home/mord/mordhau/Mordhau/Saved/Config/LinuxServer/Engine.ini
[/Script/EngineSettings.GameMapsSettings]
ServerDefaultMap=/Game/Mordhau/Maps/TaigaMap/FL_Taiga.FL_Taiga
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
