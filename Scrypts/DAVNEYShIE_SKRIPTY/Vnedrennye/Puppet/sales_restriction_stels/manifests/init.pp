#
# Класс для ограничения продаж по ЕГАИС, если не выгрузились справочники с новой МРЦ.
#
# Класс меняет порты УТМ с 8082 на 8080, тем самым УТМ перестает работать.
#
#

class sales_restriction_stels (
)
{

    file { "ogran.sh" :
        name   => "/root/ogran.sh",
        source => "puppet:///modules/sales_restriction_stels/ogran.sh",
        mode     => "0755",
    }

    exec { "StartSalesRestriction":
        path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
        command     => "/bin/bash /root/ogran.sh",
        require     => [ File['ogran.sh']],
        subscribe   => [ File['ogran.sh']],
        refreshonly => true,
        logoutput   => true,
    }
}