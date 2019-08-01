#!/bin/bash

# Группы магазинов = ID группы
# Аккара           = _group_01_8150844e
# Акула            = _group_25_de55e032
# Алко-Маркет      = _group_02_e7f9546c
# Анабас           = _group_03_e56b89b8
# Белуга           = _group_04_4a13f8d0
# Варадон          = _group_05_f01b5f39
# Гурами           = _group_06_13d8977c
# Дакар            = _group_07_8945bcae
# Дорада           = _group_08_119aba7b
# Калабан          = _group_09_c34c304c
# Карбина          = _group_10_fa7e3b7a
# Кардинал         = _group_11_44ab3cc3
# Лабрак           = _group_12_2d82cdc8
# Локус            = _group_13_d4365235
# Мармир           = _group_14_c0105eaa
# Миксина          = _group_15_1c907db0
# Минога           = _group_16_fcc94bc4
# Мурена           = _group_17_f681f564
# Нилус            = _group_18_d9b2ba29
# Оскар            = _group_20_44e4ea5e
# Паламида         = _group_19_ec465e02
# СИМА ООО         = _group_31_74916a19
# СТЭЛС            = _group_21_81cef5a4
# Саян-Алко        = _group_22_b3acbcf9
# Сейла            = _group_23_394298b9
# Сиган            = _group_24_c137ccd3
# Скат             = _group_26_beaf328a
# Султан           = _group_27_63419b9a
# Трута            = _group_28_58ac50bc
# Туна             = _group_29_6e3c2367
# Фарида           = _group_30_e92fcc1e

# ID магазина
SHOPID=_shop_999_3ee76fab
# ID группы
GROUPID=_group_1_e699d044



#Получаем информацию о магазине
curl http://127.0.0.1:8080/CSrest/rest/shops/$SHOPID > $SHOPID.json
#Меняем информацию о группе
sed -i "s/\"parentType\"\:\"GROUP\"\,\"parentCode\"\:\".*\"\}\,\"parentObjectIsSet/\"parentType\"\:\"GROUP\"\,\"parentCode\"\:\"$GROUPID\"\}\,\"parentObjectIsSet/g" $SHOPID.json
#Отправляем изменения на КС
curl -H "Content-Type: application/json" -XPUT http://127.0.0.1:8080/CSrest/rest/shops/$SHOPID --data @$SHOPID.json
rm $SHOPID.json
