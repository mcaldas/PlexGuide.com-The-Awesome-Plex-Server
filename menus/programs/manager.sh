#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

export NCURSES_NO_UTF8_ACS=1
## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
domain=$( cat /var/plexguide/server.domain )

HEIGHT=16
WIDTH=38
CHOICE_HEIGHT=10
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - Manager Programs"

OPTIONS=(A "Couchpotato"
         B "Headphones"
         C "Lazy Librarian"
         D "Lidarr"
         E "MEDUSA"
         F "Mylar"
         G "Radarr"
         H "Sickrage"
         I "Sonarr"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      display=CouchPotato
      program=couchpotato
      port=5050
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags couchpotato &>/dev/null &
      sleep 2 
      cronskip="no"
      ;;
    B)
      display=Headphones
      program=headphones
      port=8081
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags headphones &>/dev/null &
      cronskip="no"
      sleep 2
      ;;
    C)
      display=LazyLibrarian
      program=lazy
      port=5299
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lazy &>/dev/null &
      cronskip="no"
      sleep 2
      ;;
    D)
      display=Lidarr
      program=lidarr
      port=8686
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lidarr &>/dev/null &
      sleep 2
      cronskip="no"
      ;;
    E)
      display=MEDUSA
      program=medusa
      port=8081
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags medusa &>/dev/null &
      cronskip="no"
      sleep 2
      ;;
    F)
      display=Mylar
      program=mylar
      port=8090
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags mylar &>/dev/null &
      cronskip="no"
      sleep 2
      ;;
    G)
      display=Radarr
      program=radarr
      port=7878
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr 1>/dev/null 2>&1
      chown 1000:1000 /opt/appdata/radarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      chmod 0755 /opt/appdata/radarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      cronskip="no"
      ;;
    H)
      display=SickRage
      program=sickrage
      port=8082
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sickrage &>/dev/null &
      cronskip="no"
      sleep 2
      ;;
    I)
      display=Sonarr
      program=sonarr
      port=8989
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr 1>/dev/null 2>&1
      chown 1000:1000 /opt/appdata/sonarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      chmod 0755 /opt/appdata/sonarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      cronskip="no"
      ;;
    Z)
      exit 0 ;;
esac
    clear

########## Cron Job a Program
echo "$program" > /tmp/program_var
if [ "$cronskip" == "yes" ]; then
    clear 1>/dev/null 2>&1
else
    bash /opt/plexguide/menus/backup/main.sh
fi 

echo "$program" > /tmp/program
echo "$port" > /tmp/port

#### Pushes Out Ending
bash /opt/plexguide/menus/programs/ending.sh

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/manager.sh
