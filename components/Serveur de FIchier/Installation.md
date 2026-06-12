## Mise en place du Stockage Avancé et des Dossiers Partagés

- [Partitionnement du Stockage](Stockage-:-RAID-1)
- [Partage de Dossiers](Dossiers-Partagés)

**Prérequis techniques :**

Avoir un Windows Server 2025 à jour
Le serveur doit avoir une adresse IP statique.
Il est recommandé d'appliquer ces rôles sur une machine dédiée pour sécuriser les données et limiter les risques de pertes.
Avoir 2 disques durs en plus du disque Système /ou/ 1 disque partitionner en 2 en plus du disque Système


### Stockage : RAID 1

- Ouvrir la fenêtre **Gestion des disques** ou **Disk Management**
- Valider le formatage des Disques nouvellement mis en place en **MBR**
- Faire un clique droit sur l'un des disques et sélectionner **Un nouveau volume en miroir** ou **New Mirrored Volume**
<img width="661" height="264" alt="image" src="https://github.com/user-attachments/assets/870103f5-c817-4dcf-8788-de7ea82a0fe7" />

- Glisser les 2 disques souhaités sur le côté droit en cliquant sur chaque disque puis sur **Add**
- Nommer le nouveau stockage et choisir l'emplacement du lecteur. Pour notre exemple ce sera _BackUp_ sur le lecteur _S:_
- Une fois la configuration terminée un pourcentage de progression va apparaître
- Les Disques sont prêts quand leur statut affiche **Sain** ou **Healthy**

### Dossiers Partagés

- Pour commencer, créer les dossiers souhaités dans le stockage nouvellement construit. Dans notre cas les dossiers seront nommés : **Individuel**, **Departement** et **Service** / Le tout dans le dossier **Partage**
La commande suivante peut être utilisée sur PowerShell (mais une approche graphique peut aussi fonctionner) :
``` powershell
New-Item -Path "D:\Partage\Individuel"   -ItemType Directory -Force
```
- On crée 3 partages distincts, le ``$`` rend le partage non visible dans l'explorateur et ``-FolderEnumerationMode AccessBased`` masque les dosiers auxquels l'utilisateur n'a pas accès
```powershell
New-SmbShare -Name "Individuel$" -Path "D:\Partage\Individuel" `
    -FullAccess "Administrators" `
    -ChangeAccess "Authenticated users" `
    -FolderEnumerationMode AccessBased
```
