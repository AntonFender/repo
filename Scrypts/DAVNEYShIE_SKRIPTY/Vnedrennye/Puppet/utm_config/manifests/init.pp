#
# = Класс: utm_config
#
# Этот класс используется для распрастранения файлов конфигурации agent.properties и transport.properties
#
#

class utm_config (
)
{

    file { "supervisor.sh" :
        name   => "/root/supervisor.sh",
        source => "puppet:///modules/utm_config/supervisor.sh",
        mode     => "0755",
    }

    exec { "restartSupervisor":
        path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
        command     => "/bin/bash /root/supervisor.sh",
        require     => [ File['supervisor.sh']],
        subscribe   => [ File['supervisor.sh']],
        refreshonly => true,
        logoutput   => true,
    }
}