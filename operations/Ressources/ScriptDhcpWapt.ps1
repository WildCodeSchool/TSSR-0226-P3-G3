$waptserver_ipaddress_tftp = "172.16.6.18"
$url_waptserver = "http://srv-wapt.pharmgreen.lan"
$keymap = "fr"

Add-DhcpServerv4Class -Name "legacy_bios" -Type Vendor -Data "PXEClient:Arch:00000"
Add-DhcpServerv4Class -Name "iPXE" -Type User -Data "iPXE"

Set-DhcpServerv4OptionValue -OptionId 66 -Value "$waptserver_ipaddress_tftp"

# Premier boot UEFI → charge ipxe.efi depuis le TFTP
Add-DhcpServerv4Policy -Name "boot_uefi" -Condition AND -UserClass NE,iPXE -VendorClass NE,legacy_bios*
Set-DhcpServerv4OptionValue -PolicyName "boot_uefi" -OptionID 67 -Value "efi/boot/bootmgfw.efi"

# Deuxième boot (client iPXE UEFI) → URL script WAPT
Add-DhcpServerv4Policy -Name "wapt-ipxe-url-uefi" -Condition AND -UserClass EQ,iPXE -VendorClass NE,legacy_bios*
Set-DhcpServerv4OptionValue -PolicyName "wapt-ipxe-url-uefi" -OptionID 67 -Value "$url_waptserver/api/v3/baseipxe?uefi=true&keymap=$keymap"
