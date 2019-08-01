#
# Класс для ограничения продаж по ЕГАИС, если не выгрузились справочники с новой МРЦ.
#
# Класс меняет порты УТМ с 8082 на 8080, тем самым УТМ перестает работать.
#
#

class sales_restriction_stelsalco (
)
{

    file { "mrcutmstatus.sh" :
        name   => "/root/mrcutmstatus.sh",
        source => "puppet:///modules/sales_restriction_stelsalco/mrcutmstatus.sh",
		owner    => "root",
		group    => "root",
        mode     => "0777",
    }

    exec { "StartSalesRestriction":
        path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
        command     => "/bin/bash /root/mrcutmstatus.sh",
        require     => [ File['mrcutmstatus.sh']],
        subscribe   => [ File['mrcutmstatus.sh']],
        refreshonly => true,
        logoutput   => true,
    }
}