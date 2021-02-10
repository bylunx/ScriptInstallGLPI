 #!/bin/bash

Red="$(tput bold ; tput setaf 1)" #Ecriture coloré plus agréable
Green="$(tput bold ; tput setaf 2)"
Blue="$(tput bold ; tput setaf 4)"
ResetColor="$(tput sgr0)"

server_ip="192.168.14.110"
network_ip="192.168.14.0"

  echo "L'adresse ip du serveur : $server_ip "

packages=("fusioninventory-agent" "fusioninventory-agent-task-network" "nmap") # Paquets nécessaire


dpkg -l "${packages[@]}" > /dev/null 2>&1 && echo "${Blue}fusioninventory a déjà été installée${ResetColor}" || sudo apt-get install -y "${packages[@]}" > /dev/null 2>&1


if [[ $? -ge 1 ]]; then
  echo "${Red}L'installation a échouée${ResetColor}"
  exit 1
  else
  echo "${Green}L'installation a fonctionné${ResetColor}"
fi
if [[ (-e "/etc/fusioninventory/agent.cfg") && (-e "/etc/default/fusioninventory-agent") ]]; then
  sudo sed -i "s/#\(server = http:\/\/\(.*\)\/glpi\/plugins\/fusioninventory\/\)/\1/g" /etc/fusioninventory/agent.cfg
  sudo sed -i "s/server.domain.com\//$server_ip\//g" /etc/fusioninventory/agent.cfg

  sudo sed -i "s/\(scan-homedirs *=\).*/\1 1/" /etc/fusioninventory/agent.cfg

  sudo sed -i "s/^\(MODE=\).*/\1daemon/" /etc/default/fusioninventory-agent
  echo -e "${Green}Les lignes du fichier de configurations ont été modifiés :${ResetColor}"
  grep -E "(^server)" /etc/fusioninventory/agent.cfg

  sudo service fusioninventory-agent restart && echo "${Green}Service redémarré${ResetColor}" || echo "${Red}Le service n'a pas pu être lancé${ResetColor}"
else
  echo "${Red}Les fichiers de configurations sont absents${ResetColor}"
fi