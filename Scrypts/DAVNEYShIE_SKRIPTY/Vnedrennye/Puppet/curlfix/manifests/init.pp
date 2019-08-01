class Curlfix (
)
{
    file { "curl_7.35.0-1ubuntu2.7_i386.deb" :
        name   => "/root/curl_7.35.0-1ubuntu2.7_i386.deb",
        source => "puppet:///modules/Curlfix/curl_7.35.0-1ubuntu2.7_i386.deb",
        require     => [ File[ 'libcurl3_7.35.0-1ubuntu2.7_i386.deb' ], File[ 'librtmp0_2.4+20121230.gitdf6c518-1_i386.deb' ] ],
    }
    file { "libcurl3_7.35.0-1ubuntu2.7_i386.deb" :
        name   => "/root/libcurl3_7.35.0-1ubuntu2.7_i386.deb",
        source => "puppet:///modules/Curlfix/libcurl3_7.35.0-1ubuntu2.7_i386.deb",
    }
    file { "librtmp0_2.4+20121230.gitdf6c518-1_i386.deb" :
        name   => "/root/librtmp0_2.4+20121230.gitdf6c518-1_i386.deb",
        source => "puppet:///modules/Curlfix/librtmp0_2.4+20121230.gitdf6c518-1_i386.deb",
    }
    file { "installCurl.sh" :
        name   => "/root/installCurl.sh",
        source => "puppet:///modules/Curlfix/installCurl.sh",
        mode     => "0755",
    }
    exec { "installCurl":
       path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
       command     => "/bin/bash /root/installCurl.sh",
       onlyif      => ["test -f /root/curl_7.35.0-1ubuntu2.7_i386.deb"],
       require     => [ File['installCurl.sh'], File['curl_7.35.0-1ubuntu2.7_i386.deb'], File['libcurl3_7.35.0-1ubuntu2.7_i386.deb'], File['librtmp0_2.4+20121230.gitdf6c518-1_i386.deb'] ],
       subscribe   => [ File['installCurl.sh'], File['curl_7.35.0-1ubuntu2.7_i386.deb'], File['libcurl3_7.35.0-1ubuntu2.7_i386.deb'], File['librtmp0_2.4+20121230.gitdf6c518-1_i386.deb'] ],
       refreshonly => true,
       logoutput   => true,
    }
}


