class stels_logrotate (
)
{
	file { "RmLogsDelete.sh" :
    		name   => "/opt/RmLogsDelete.sh",
    		source => "puppet:///modules/stels_logrotate/RmLogsDelete.sh",
			mode   => "0777",
    }
	file { "rsyslog" :
    		name   => "/etc/logrotate.d/rsyslog",
    		source => "puppet:///modules/stels_logrotate/rsyslog",
			mode   => "0644",
    }
	
	file { "StatusKassa" :
    		name   => "/etc/logrotate.d/StatusKassa",
    		source => "puppet:///modules/stels_logrotate/StatusKassa",
			mode   => "0644",
    }
	
	exec { "RunRmLogsDelete" :
        path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games',
        command     => '/bin/bash /opt/RmLogsDelete.sh',
		onlyif      => ["test -f /opt/RmLogsDelete.sh"],
		require		=> [ File[ 'RmLogsDelete.sh' ] ],
		subscribe   => [ File[ 'RmLogsDelete.sh' ] ],
		refreshonly => true,
		logoutput   => true,
    }
	
}