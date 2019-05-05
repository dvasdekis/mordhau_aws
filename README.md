# Mordhau Dedicated Server on AWS
Mordhau one-liner dedicated server start script for an AWS Ubuntu 18.04 instance

## Steps

1. Manually start a Ubuntu 18.04 EC2 instance
    * Set security group to allow inbound SSH, ICMP, 7777, 7778, 27015. For improved security disable SSH later
    * Tested with good performance for 64 players on c5.large (2x 3.5GHz boost Xeon vCPUs, 8GB RAM, probably overkill) with 8GB SSD. Ram usage was less than 1.5GB
      * t3-small (2GB RAM, 2 vCPUs) might be worth testing

2. SSH in and run

      `curl -LJO https://raw.githubusercontent.com/TimHugall/mordhau_aws/dev_ubuntu/start.sh && sudo bash start.sh`

3. Enter Steam username, password, authentication code and server details when prompted

4. Server script runs in screen - use `Ctrl + A` then `D` to detach, use `sudo -u mord screen -r` to reattach

5. For debugging, edit the script to remove screen commands on MordhauServer.sh so the yellow errors can be more easily seen

## To do (no particular order)

1. Interactive script improvements (select map rotation and default map, right now it's just frontline)
2. Can't login anonymously for Mordhau but look into future possibility of running bootstrap without SSH in (right now it's needed for Steam Guard    authentication, so might as well have the other interactive details there)
3. Clean up bash script

## Problems / bugs

1. 'Failed to join server' on first few attempts
3. Engine.ini gets cleared unless write permissions are restricted
