#!/bin/bash

#on utilise un fichier temporaire pour fermer le script s'il est déjà en cours d'exécution
if [ -e "/tmp/dropbox-is-syncing" ]; then
    exit
else
    touch "/tmp/dropbox-is-syncing"
fi

#on lance la synchronisation depuis le remote "dropbox" vers un dossier local ~/Dropbox
#PENSER A MODIFIER LE NOM DU REMOTE EN FONCTION DE CE QUI A ETE RENTRE PENDANT LA CONF RCLONE
/usr/bin/rclone sync dropbox: /home/UTILISATEUR/Dropbox

#on supprime le fichier temporaire une fois la synchronisation terminée
rm "/tmp/dropbox-is-syncing"