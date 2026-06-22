## Création d'un rôle File Server Resource Manager (FSRM)

- Entrer sur PowerShell la cmdlet suivante : 
```powershell
Install-WindowsFeature -Name FS-Resource-Manager -IncludeManagementTools
```

- Créer un quota d'utilisation d'espace de stockage
Ouvrir le **File Server Resource Manager** et cliquer sur **Quota Templates** puis sélectionner le template voulu pour le modifier avec un clique droit suivi de **Edit template**

<img width="1183" height="353" alt="Quota FSRM" src="https://github.com/user-attachments/assets/5bcbf73e-a58b-4007-8c94-75125d3f1613" />

<img width="1058" height="298" alt="Quota FSRM 2" src="https://github.com/user-attachments/assets/ebb1f490-f023-49ff-9829-dff8845a08a9" />

Appliquer la limite désirée et le mail d'aministration qui recevra les alertes puis cliquer sur **Create**

<img width="1055" height="537" alt="Quota FSRM 2 2" src="https://github.com/user-attachments/assets/c511912b-bac4-4796-9c74-bdbef8ebd610" />

Une fois le quota mis en place vous recevrez des alertes par mail (si configuré) et dans l'Observateur d'évènements si un Utilisateur dépasse la limite autorisée

<img width="827" height="496" alt="Quota FSRM 3" src="https://github.com/user-attachments/assets/8e30c8e9-96c6-4acd-ae8a-896ccb06ef92" />
