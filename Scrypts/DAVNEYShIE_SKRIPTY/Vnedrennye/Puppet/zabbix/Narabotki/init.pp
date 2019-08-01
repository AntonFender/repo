class stels_zabbix (
	$ip_server			= '192.168.0.9',
	$zabbix_server		= '192.168.0.9,10.9.0.1',
	$hostname_server	= 'zabbix',
	$timeout_zabbix		= 30,
	$route_host			= 'route add -host 192.168.0.9 gw 10.9.0.1'
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
	
	package { 'zabbix_agent' :
		name		=> 'zabbix-agent',
		provider	=> 'aptitude',
		require		=> [ Exec[ 'Updateapt' ], File[ 'zabbix.list' ]  ],
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
		require		=> [ Package[ 'zabbix_agent' ], Exec[ 'Updateapt' ], File[ 'zabbix.list' ]  ],
	}
	
	file { 'rc.local' :
		name	=> "/etc/rc.local",
		content	=> template("stels_zabbix/rc.local.erb"),
		mode     => "0777",
	}
	
}