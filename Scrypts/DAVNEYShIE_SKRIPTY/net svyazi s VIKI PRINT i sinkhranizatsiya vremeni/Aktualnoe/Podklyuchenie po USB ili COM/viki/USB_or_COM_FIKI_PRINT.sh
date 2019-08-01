#!/bin/bash

echo "Для продолжения выберите следующие действия (1 - USB, 2 - COM):"

read Key
		case "$Key" in
		"2" )
			echo "Устанавливаем COM режим для VIKI PRINT"
				rm /linuxcash/cash/conf/drivers/hw::PiritFiscalRegister*
				rm /linuxcash/cash/conf/drivers/hw::Serial_*
				rm /linuxcash/cash/conf/drivers/hw::SerialFactory*
					cp /root/viki/COM/hw::PiritFiscalRegister_0.xml /linuxcash/cash/conf/drivers/
					cp /root/viki/COM/hw::PiritFiscalRegisterFactory.xml /linuxcash/cash/conf/drivers/
					cp /root/viki/COM/hw::Serial_0.xml /linuxcash/cash/conf/drivers/
					cp /root/viki/COM/hw::SerialFactory.xml /linuxcash/cash/conf/drivers/
		reboot
		;;
		"1" )
echo "Устанавливаем USB режим для VIKI PRINT"
		cd /etc/udev/rules.d/
		touch 40_artix_viki.rules
echo SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"5740\", SYMLINK+=\"ttySviki\" > /etc/udev/rules.d/40_artix_viki.rules
		udevadm control --reload-rules
			rm /linuxcash/cash/conf/drivers/hw::PiritFiscalRegister*
			rm /linuxcash/cash/conf/drivers/hw::Serial_*
			rm /linuxcash/cash/conf/drivers/hw::SerialFactory*
				cp /root/viki/USB/hw::PiritFiscalRegister_0.xml /linuxcash/cash/conf/drivers/
				cp /root/viki/USB/hw::PiritFiscalRegisterFactory.xml /linuxcash/cash/conf/drivers/
				cp /root/viki/USB/hw::Serial_0.xml /linuxcash/cash/conf/drivers/
				cp /root/viki/USB/hw::SerialFactory.xml /linuxcash/cash/conf/drivers/
reboot
		;;
		esac












