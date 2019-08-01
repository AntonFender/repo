class stels_zabbix (
	$ip_server		= '192.168.0.9',
	$zabbix_server		= '192.168.0.9,10.9.0.1',
	$hostname_server	= 'zabbix',
	$timeout_zabbix		= 30,
	$host_name = $::hostname
)
{
	File {
		owner => 'root',
		group => 'root',
		mode  => '0644',
	}
	
	exec { "Updateapt" :
        path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games',
        command     => '/usr/bin/aptitude update',
        logoutput   => true,
	require		=> File[ 'zabbix.list' ],
    } 
	
	exec { "installzabbix" :
        path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
        command     => "sudo apt-get install -y --force-yes zabbix-agent",
        require		=> [ Exec[ 'Updateapt' ], File[ 'zabbix.list' ]  ],
	subscribe   => File[ 'zabbix.list' ],
	refreshonly => true,
	logoutput   => true,
	}
		
	exec { "zabbixrestart" :
        path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
        command     => "sudo service zabbix-agent restart",
        require		=> [ Exec[ 'Updateapt' ], File[ 'zabbix.list' ], Exec[ 'installzabbix' ], File[ 'hosts' ], File[ 'zabbix_agentd' ] ],
        subscribe   => File[ 'zabbix_agentd' ],
	refreshonly => true,
	logoutput 	=> true,
	}
	
	file { 'hosts' :
		name	=> "/etc/hosts",
		content	=> template("stels_zabbix/hosts.erb"),
	}
	
	
	file { "zabbix.list" :
    		name   => "/etc/apt/sources.list.d/zabbix.list",
    		source => "puppet:///modules/stels_zabbix/zabbix.list",
    }
	
	file { 'zabbix_agentd' :
		name		=> "/etc/zabbix/zabbix_agentd.conf",
		content		=> template("stels_zabbix/zabbix_agentd.erb"),
		require		=> [ Exec[ 'installzabbix' ], Exec[ 'Updateapt' ], File[ 'zabbix.list' ]  ],
	}
	
}