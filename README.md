Official installation https://linuxgsm.com/lgsm/rustserver/

LGSM Dependencies in the link above

Dependencies `sudo apt -y install curl python3 zip unzip`

Install this fork:
1. wget -O linuxgsm.sh https://linuxgsm.sh
2. Modify 
```
githubuser="A-GK"
githubrepo="tinity_lgsm"
githubbranch="master"
```
3. chmod +x linuxgsm.sh && bash linuxgsm.sh rustserver
4. ./rustserver install
5. ./rustserver mods-install
6. ./rustserver start

Update this branch: ./rustserver ul