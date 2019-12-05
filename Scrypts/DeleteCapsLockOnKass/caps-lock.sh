#!/bin/bash
#************************************************#
#                 stels.sh                       #
#              Октябрь 01, 2019                  #
#                                                #
#            Выключение caps lock	       	     #
#************************************************#



CapsLockoff(){

if [ -f /usr/share/X11/xkb/keycodes/$1 ]; then
	if grep -il "caps" /usr/share/X11/xkb/keycodes/$1; then	
	DeleteCapsLock==$(egrep 'Caps' /usr/share/X11/xkb/keycodes/$1)
	DeleteCapsLockInclude==$(egrep 'CAPS' /usr/share/X11/xkb/keycodes/$1)
	sed -i '/CAPS/d' /usr/share/X11/xkb/keycodes/$1
	sed -i '/Caps/d' /usr/share/X11/xkb/keycodes/$1
		echo `date +'%d.%m.%Y %H:%M:%S'` $1 " готов. Удалены строки: "  $DeleteCapsLock " И " $DeleteCapsLockInclude
			else 
		echo `date +'%d.%m.%Y %H:%M:%S'` $1 "Сделана ранее. Удалены строки: "  $DeleteCapsLock " И " $DeleteCapsLockInclude
fi fi

}

RunCapsLockoff() {

CapsLockoff "xfree98"
CapsLockoff "amiga"
CapsLockoff "evdev"
CapsLockoff "fujitsu"
CapsLockoff "hp"
CapsLockoff "ibm"
CapsLockoff "macintosh"
CapsLockoff "sony"
CapsLockoff "sun"
CapsLockoff "xfree86"

}

RunCapsLockAdd(){

sed -i '/indicator 2 = "Kana";/ { N; s/    indicator 2 = "Kana";\n/    indicator 1 = "Caps Lock";\n&/ }' /usr/share/X11/xkb/keycodes/xfree98
sed -i '/<LCTL> =  124;/a \    <CAPS> =  121;' /usr/share/X11/xkb/keycodes/xfree98
sed -i '/<LCTL> = 107;/a \    <CAPS> = 106;' /usr/share/X11/xkb/keycodes/amiga
sed -i '/indicator 2  = "Num Lock";/ { N; s/\tindicator 2  = "Num Lock";\n/\tindicator 1 = "Caps Lock";\n&/ }' /usr/share/X11/xkb/keycodes/evdev
sed -i '/<AC01> = 38;/ { N; s/\t<AC01> = 38;\n/\t<CAPS> = 66;\n&/ }' /usr/share/X11/xkb/keycodes/evdev
sed -i '/<LALT> = 27;/ { N; s/    <LALT> = 27;\n/    <CAPS> = 127;\n&/ }' /usr/share/X11/xkb/keycodes/fujitsu
sed -i '/indicator 2 = "Num Lock";/ { N; s/    indicator 2 = "Num Lock";\n/    indicator 1 = "Caps Lock";\n&/ }' /usr/share/X11/xkb/keycodes/hp
sed -i '/<AC01> = 53;/ { N; s/    <AC01> = 53;\n/    <CAPS> = 55;\n&/ }' /usr/share/X11/xkb/keycodes/hp
sed -i '/<AC01> = 37;/ { N; s/    <AC01> = 37;\n/    <CAPS> = 29;\n&/ }' /usr/share/X11/xkb/keycodes/hp
sed -i '/indicator 2 = "Num Lock";/ { N; s/    indicator 2 = "Num Lock";\n/    indicator 1 = "Caps Lock";\n&/ }' /usr/share/X11/xkb/keycodes/ibm
sed -i '/<AC01> = 39;/ { N; s/    <AC01> = 39;\n/    <CAPS> = 38;\n&/ }' /usr/share/X11/xkb/keycodes/ibm
sed -i '/indicator 2 = "Num Lock";/a \    indicator 1 = "Caps Lock";' /usr/share/X11/xkb/keycodes/macintosh
sed -i '/<AC01> = 8;/ { N; s/    <AC01> = 8;\n/    <CAPS> = 65;\n&/ }' /usr/share/X11/xkb/keycodes/macintosh
sed -i '/<LALT> = 74;/a \    <CAPS> = 75;' /usr/share/X11/xkb/keycodes/sony
sed -i '/<POWR> = 55;/a \    indicator 4 = "Caps Lock";' /usr/share/X11/xkb/keycodes/sun
sed -i '/<LALT> = 26;/a \    <CAPS> = 126;' /usr/share/X11/xkb/keycodes/sun
sed -i '/indicator 2 = "Num Lock";/ { N; s/    indicator 2 = "Num Lock";\n/    indicator 1 = "Caps Lock";\n&/ }' /usr/share/X11/xkb/keycodes/xfree86
sed -i '/<AC01> =  38;/ { N; s/    <AC01> =  38;\n/    <CAPS> =  66;\n&/ }' /usr/share/X11/xkb/keycodes/xfree86

}


#RunCapsLockoff
#RunCapsLockAdd



exit 0