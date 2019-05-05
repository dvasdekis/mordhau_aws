# Mordhau Dedicated Server on AWS
Mordhau dedicated server one-liner start script for an AWS EC2 Ubuntu 18.04 instance

## Steps

1. Manually start a Ubuntu 18.04 EC2 instance
    * Set security group to allow inbound SSH, ICMP, 7777, 7778, 27015. For improved security disable SSH later
    * Tested with good performance for 64 players on c5.large (2x 3.5GHz boost Xeon vCPUs, 8GB RAM, probably overkill) with 8GB SSD. Ram usage was less than 1.5GB
      * t2-small (2GB RAM, 1 vCPU) might be worth testing as server basically runs on a single core

2. SSH in and run

      `curl -LJO https://raw.githubusercontent.com/TimHugall/mordhau_aws/dev/start.sh && sudo bash start.sh`

3. Enter Steam username, password, authentication code and server details when prompted

4. Server script runs in screen daemon by default

## To do (no particular order)

1. Interactive script improvements, perhaps have user specify Github gist file link to use their own configs
2. Can't login anonymously for Mordhau but look into future possibility of running bootstrap without SSH in (right now it's needed for Steam Guard    authentication, so might as well have the other interactive details there)
3. Clean up bash script

## Problems / bugs

1. Currently error towards the end of script, need to test more
2. Engine.ini gets cleared unless write permissions are restricted
