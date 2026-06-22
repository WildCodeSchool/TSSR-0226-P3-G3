if (-not (Test-Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.exe")) {
    msiexec /i "\\PG-00005-X00001\Ressources\zabbix_agent2-7.4.11-windows-amd64-openssl.msi" /quiet `
        SERVER=172.16.6.19 `
        SERVERACTIVE=172.16.6.19 `
        ENABLEPATH=1
}