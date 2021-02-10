# Welcome to the ScriptInstallGLPI wiki!

# Mise en place d’un script

Après avoir procédé à l’installation des différents paquets sur une machine, nous allons écrire un script qui permet de faciliter l’installation et la configuration des paquets. En effet, pour déployer une telle installation, il est préférable d’avoir un script qui automatise les tâches sur toutes les machines, car les manipulations sont longues et rébarbatives. Nous pouvons donc exécuter ce script en parallèle SSH ou autre, très facilement. Dans notre cas, le script sera installé sur la version backup du système d’exploitation qui se réinitialise sur tout les postes de la salle à une certaine période de temps.

Voici une explication détaillé du script : Le code ci-dessous permet une écriture coloré et plus agréable du texte qu’affiche le script.

`Red="$(tput bold ; tput setaf 1)" 
Green="$(tput bold ; tput setaf 2)" 
Blue="$(tput bold ; tput setaf 4)" 
ResetColor="$(tput sgr0)"`

Ces variables permettent de définir l’adresse du serveur GLPI et l’adresse du réseau pour les configurations du plugin :

` server_ip="192.168.14.110" 2 network_ip="192.168.14.0"`

On définit les paquets nécessaire au fonctionnement dans une liste, puis on utilise la commande dpkg -l pour faire la liste des paquets installés, pour vérifier si les paquets nécessaire sont déjà installés. Si oui, on affiche un message à l’utilisateur pour lui prévenir, sinon on les installe.

`packages=("fusioninventory-agent" "fusioninventory-agent-task-network" "nmap") 
 dpkg -l "${packages[@]}" > /dev/null 2>&1 && echo "${Blue}fusioninventory a déjà été installée${ ResetColor}" || sudo apt-get install -y "${packages[@]}" > /dev/null 2>&1`

La condition ligne 19 permet de vérifier le fonctionnement grâce au message d’erreur, si la sortie d’erreur est égale à 0, il n’y pas de problème, si elle est supérieur, on affiche un message d’erreur :

`if [[ $ ? -ge 1 ]];
then`

 Ensuite, ligne 25 on vérifie l’existence du fichier de configuration, et on remplace toutes les valeurs par celles correspondantes au serveur grâce à la commande sed. On redémarre maintenant le service (fusion-inventory) en affichant un message d’information :

`if [[ (-e "/etc/fusioninventory/agent.cfg") && (-e "/etc/default/fusioninventory-agent") ]]; then`
