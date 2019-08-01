class utm308 (
)
{
    file { "u-trans-3_0_8.deb" :
        name   => "/root/u-trans-3_0_8.deb",
        source => "puppet:///modules/utm308/u-trans-3_0_8.deb",
        require     => [ File[ 'idprotectclient_637.03-0_i386.deb' ], File[ 'jcgostclient_1.5.3_i386.deb' ], File[ 'libccid_1.4.15-1_i386.deb' ], File[ 'pcscd_1.8.10-1ubuntu1_i386.deb' ] ],
    }
    file { "idprotectclient_637.03-0_i386.deb" :
        name   => "/root/idprotectclient_637.03-0_i386.deb",
        source => "puppet:///modules/utm308/idprotectclient_637.03-0_i386.deb",
    }
    file { "jcgostclient_1.5.3_i386.deb" :
        name   => "/root/jcgostclient_1.5.3_i386.deb",
        source => "puppet:///modules/utm308/jcgostclient_1.5.3_i386.deb",
    }
    file { "libccid_1.4.15-1_i386.deb" :
        name   => "/root/libccid_1.4.15-1_i386.deb",
        source => "puppet:///modules/utm308/libccid_1.4.15-1_i386.deb",
    }
    file { "pcscd_1.8.10-1ubuntu1_i386.deb" :
        name   => "/root/pcscd_1.8.10-1ubuntu1_i386.deb",
        source => "puppet:///modules/utm308/pcscd_1.8.10-1ubuntu1_i386.deb",
    }
    file { "python-meld3_0.6.10-1_i386.deb" :
        name   => "/root/python-meld3_0.6.10-1_i386.deb",
        source => "puppet:///modules/utm308/python-meld3_0.6.10-1_i386.deb",
    }
    file { "supervisor_3.0b2-1ubuntu0.1_all.deb" :
        name   => "/root/supervisor_3.0b2-1ubuntu0.1_all.deb",
        source => "puppet:///modules/utm308/supervisor_3.0b2-1ubuntu0.1_all.deb",
    }
    file { "installUtm.sh" :
        name   => "/root/installUtm.sh",
        source => "puppet:///modules/utm308/installUtm.sh",
        mode     => "0755",
    }
    exec { 'egaisflag' :
        command     => "dpkg -l u-trans | grep 3.0.8 |tee /root/egaisFlag",
        cwd         => '/root',
        path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games',
        subscribe   => [ File[ 'u-trans-3_0_8.deb' ], File[ 'installUtm.sh' ] ],
        refreshonly => true,
        logoutput => true,
    }
    exec { "installUtm":
        path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
        command     => "/bin/bash /root/installUtm.sh",
        require     => [ Exec[ 'egaisflag' ] ],
        onlyif      => "test -f /root/egaisFlag",
        logoutput => true,
    }
}


