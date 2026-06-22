Ouvrir la Console **DNS** sur le **Server Manager**

--------------------------------------------------------

## Création d'une zone directe (_Forward Lookup Zones_)

- Cliquer avec le bouton droit de la souris sur **Forward Lookup Zones** et cliquer sur **New Zone**
- Cliquer sur **Next**
- Choisir l'option par défaut **Primary zone** puis cliquer sur **Next**
- Mettre un nom de zone **DNS** comme _nomdezone.fr_
- Cliquer sur **Next** plusieurs fois puis **Finish** à la fin
- La zone **DNS** apparaît sous **Forward Lookup Zones**
--------------------------------------------------------

## Création d'une zone indirecte (_Reverse Lookup Zones_)

- Cliquer avec le bouton droit de la souris sur **Reverse Lookup Zones** et cliquer sur **New Zone**
- Cliquer sur **Next**
- Choisir l'option par défaut **Primary zone** puis cliquer sur **Next**
- Choisir l'option par défaut IPv4 **Reverse Lookup Zone** puis cliquer sur **Next**
- Dans **Network ID** mettre le début de la plage IP correspondant à cette zone
- Cliquer sur **Next** plusieurs fois puis **Finish** à la fin
- La zone **DNS** indirecte apparaît sous **Reverse Lookup Zones**
-------------------------------------------------------

## Création d'un enregistrement A

Dans la zone DNS créée :
- Clique avec le bouton droit de la souris et sélectionne **New Host** (_A or AAAA_)
- Mettre un nom **DNS** et une adresse IP associée
-------------------------------------------------------

## Création d'un enregistrement CNAME

Dans la zone DNS créée :
- Clique avec le bouton droit de la souris et sélectionne **New Alias** (CNAME)
- Mettre un alias de nom vers une adresse IP qui a déjà un **enregistrement A**
