#!/bin/bash

#On vérifie si le dossier pour les sauvegardes existe
if test ! -e "/home/UTILISATEUR/dropbox-backups"; then
    #si ce n'est pas le cas, on le crée
    mkdir /home/UTILISATEUR/dropbox-backups
fi

#On établie la date du jour pour créer les copies et la date maximale à conserver
today=$(date +"%Y-%m-%d")
maxbackup=$(date -d "-5 days" +%s)

#On vérifie que le dossier Dropbox est bien présent, sinon le script s'arrête
if test ! -e "/home/UTILISATEUR/Dropbox"; then
    #On vérifie si le dossier log existe
    if test ! -e "/home/UTILISATEUR/dropbox-backups/error-logs"; then
        #si ce n'est pas le cas, on le crée
        mkdir /home/UTILISATEUR/dropbox-backups/error-logs
    fi
    echo "$(date) : le dossier Dropbox était manquant, la sauvegarde n'a pas été faite" >> /home/stagiaire/dropbox-backups/error-logs/$today
    exit 1
fi

#Vérifie si une sauvegarde a déjà été faite aujourd'hui, sinon la fait
if test ! -e "/home/UTILISATEUR/dropbox-backups/$today"; then
    cp -r /home/UTILISATEUR/Dropbox /home/UTILISATEUR/dropbox-backups/$today
fi

#On itère sur tous les fichiers dans nos backups pour en vérifier la date dans le nom
for backup in $(ls -1 /home/UTILISATEUR/dropbox-backups); do
    #On vérifie si $backup est bien un dossier et qu'il s'agit d'une date valide
    if [ -d "/home/UTILISATEUR/dropbox-backups/$backup" ] && date -d "$backup" >/dev/null 2>&1 ; then
        #Convertie la date du fichier en format seconde pour pouvoir comparer avec $maxbackup
        backupdate=$(date -d "$backup" +%s)
        #Si la date est antérieure à $maxbackup, on supprime le dossier
        if [ $backupdate -lt $maxbackup ]; then
            rm -r /home/UTILISATEUR/dropbox-backups/$backup
        fi
    fi
done

#On vérifie si Dropbox est bien actif pour générer une erreur si ce n'est pas le cas
if [[ $(dropbox status) = "Dropbox isn't running!" ]]; then
    #On vérifie si le dossier log existe
    if test ! -e "/home/stagiaire/dropbox-backups/error-logs"; then
        #si ce n'est pas le cas, on le crée
        mkdir /home/UTILISATEUR/dropbox-backups/error-logs
    fi
    echo "$(date) : Dropbox a été détecté comme inactif." >> /home/UTILISATEUR/dropbox-backups/error-logs/$today
fi