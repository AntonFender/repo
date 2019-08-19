class stels_logrotate (
)
{

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
}