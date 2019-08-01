class stels_help (
)
{
	file { "installUtmPython.sh" :
    		name   => "/opt/FirstHelpAndScan/installUtmPython.sh",
    		source => "puppet:///modules/stels_help/installUtmPython.sh",
			require     => [ Exec[ 'InstallPythonScan' ], File[ '/opt/FirstHelpAndScan/' ], File[ '/opt/FirstHelpAndScan/driverssource/' ] ],
			mode   => "0777",
    }
	file { "Rutoken.sh" :
    		name   => "/opt/FirstHelpAndScan/Rutoken.sh",
    		source => "puppet:///modules/stels_help/Rutoken.sh",
			require     => [ Exec[ 'InstallPythonScan' ], File[ '/opt/FirstHelpAndScan/' ], File[ '/opt/FirstHelpAndScan/driverssource/' ] ],
			mode   => "0777",
    }
	file { "ScanDriverMostCopy.sh" :
    		name   => "/opt/FirstHelpAndScan/ScanDriverMostCopy.sh",
    		source => "puppet:///modules/stels_help/ScanDriverMostCopy.sh",
			require     => [ Exec[ 'InstallPythonScan' ], File[ '/opt/FirstHelpAndScan/' ], File[ '/opt/FirstHelpAndScan/driverssource/' ] ],
			mode   => "0777",
    }
	file { "supervisorPython.sh" :
    		name   => "/opt/FirstHelpAndScan/supervisorPython.sh",
    		source => "puppet:///modules/stels_help/supervisorPython.sh",
			require     => [ Exec[ 'InstallPythonScan' ], File[ '/opt/FirstHelpAndScan/' ], File[ '/opt/FirstHelpAndScan/driverssource/' ] ],
			mode   => "0777",
    }
	file { "windows.py" :
    		name   => "/opt/FirstHelpAndScan/windows.py",
    		source => "puppet:///modules/stels_help/windows.py",
			require     => [ Exec[ 'InstallPythonScan' ], File[ '/opt/FirstHelpAndScan/' ], File[ '/opt/FirstHelpAndScan/driverssource/' ] ],
			mode   => "0777",
    }
	file { "driverssource.tar.gz" :
    		name   => "/opt/driverssource.tar.gz",
    		source => "puppet:///modules/stels_help/driverssource.tar.gz",
    }
	file { "InstallPythonAndScan.sh" :
    		name   => "/opt/InstallPythonAndScan.sh",
    		source => "puppet:///modules/stels_help/InstallPythonAndScan.sh",
			mode   => "0777",
    }
	
	
	
	file { "python-tk_2.7.5-1ubuntu1_i386.deb" :
    		name   => "/var/cache/apt/archives/python-tk_2.7.5-1ubuntu1_i386.deb",
    		source => "puppet:///modules/stels_help/python-tk_2.7.5-1ubuntu1_i386.deb",
    }
	file { "liblcms2-2_2.5-0ubuntu4.2_i386.deb" :
    		name   => "/var/cache/apt/archives/liblcms2-2_2.5-0ubuntu4.2_i386.deb",
    		source => "puppet:///modules/stels_help/liblcms2-2_2.5-0ubuntu4.2_i386.deb",
    }
	file { "libwebp5_0.4.0-4_i386.deb" :
    		name   => "/var/cache/apt/archives/libwebp5_0.4.0-4_i386.deb",
    		source => "puppet:///modules/stels_help/libwebp5_0.4.0-4_i386.deb",
    }
	file { "libwebpmux1_0.4.0-4_i386.deb" :
    		name   => "/var/cache/apt/archives/libwebpmux1_0.4.0-4_i386.deb",
    		source => "puppet:///modules/stels_help/libwebpmux1_0.4.0-4_i386.deb",
    }
	file { "python-imaging_2.3.0-1ubuntu3.4_all.deb" :
    		name   => "/var/cache/apt/archives/python-imaging_2.3.0-1ubuntu3.4_all.deb",
    		source => "puppet:///modules/stels_help/python-imaging_2.3.0-1ubuntu3.4_all.deb",
    }
	file { "python-pil_2.3.0-1ubuntu3.4_i386.deb" :
    		name   => "/var/cache/apt/archives/python-pil_2.3.0-1ubuntu3.4_i386.deb",
    		source => "puppet:///modules/stels_help/python-pil_2.3.0-1ubuntu3.4_i386.deb",
    }
	
	file {
    ['/opt/FirstHelpAndScan/', '/opt/FirstHelpAndScan/driverssource/']:
        ensure => 'directory'
	}
	
	
	exec { "InstallPythonScan" :
        path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games',
        command     => '/bin/bash /opt/InstallPythonAndScan.sh',
		onlyif      => ["test -f /var/cache/apt/archives/python-tk_2.7.5-1ubuntu1_i386.deb"],
		require		=> [ File[ 'driverssource.tar.gz' ], File[ 'InstallPythonAndScan.sh' ], File[ 'python-tk_2.7.5-1ubuntu1_i386.deb' ], File[ 'liblcms2-2_2.5-0ubuntu4.2_i386.deb' ], File[ 'libwebp5_0.4.0-4_i386.deb' ], File[ 'libwebpmux1_0.4.0-4_i386.deb' ], File[ 'python-imaging_2.3.0-1ubuntu3.4_all.deb' ], File[ 'python-pil_2.3.0-1ubuntu3.4_i386.deb' ] ],
		subscribe   => [ File[ 'InstallPythonAndScan.sh' ] ],
		refreshonly => true,
		logoutput   => true,
    }
	
	exec { "ScanDriverMostCopy.sh" :
        path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games',
        command     => '/bin/bash /opt/FirstHelpAndScan/ScanDriverMostCopy.sh',
		onlyif      => ["test -f /opt/FirstHelpAndScan/driverssource.tar.gz"],
		require		=> [ Exec[ 'InstallPythonScan' ], File[ 'ScanDriverMostCopy.sh' ] ],
		subscribe   => [ File[ 'ScanDriverMostCopy.sh' ] ],
		refreshonly => true,
		logoutput   => true,
    }
	
	

	
}