class mrcpivofix (
)
{
   file { "install.sh" :
       name   => "/root/install.sh",
       source => "puppet:///modules/mrcpivofix/install.sh",
       mode     => "0755"
   }
   file { "easyegais2.tar.gz" :
       name   => "/root/easyegais2.tar.gz",
       source => "puppet:///modules/mrcpivofix/easyegais2.tar.gz",
   }

   exec { "install":
       path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
       command     => "/bin/bash /root/install.sh",
       onlyif      => ["test -f /root/easyegais2.tar.gz"],
       require     => [ File['install.sh'], File['easyegais2.tar.gz'] ],
       subscribe   => [ File['install.sh'], File['easyegais2.tar.gz'] ],
       refreshonly => true,
       logoutput   => true,
   }
}


