class easyegais_knopka (
)
{
   file { "install.sh" :
       name   => "/root/easyegaisinstallknopka.sh",
       source => "puppet:///modules/easyegais_knopka/easyegaisinstallknopka.sh",
       mode     => "0755"
   }
   file { "easyegais22.tar.gz" :
       name   => "/root/easyegais22.tar.gz",
       source => "puppet:///modules/easyegais_knopka/easyegais22.tar.gz",
   }

   exec { "installeasyegaisknopka":
       path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
       command     => "/bin/bash /root/easyegaisinstallknopka.sh",
       onlyif      => ["test -f /root/easyegais22.tar.gz"],
       require     => [ File['easyegaisinstallknopka.sh'], File['easyegais22.tar.gz'] ],
       subscribe   => [ File['easyegaisinstallknopka.sh'], File['easyegais22.tar.gz'] ],
       refreshonly => true,
       logoutput   => true,
   }
}


