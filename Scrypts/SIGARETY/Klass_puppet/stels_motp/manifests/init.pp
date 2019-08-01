class stels_motp (
    $include_motp                       = 'on',
    $maska_tobacco                  	= '\d{14}.{15}|01\d{14}21.{7}8005\d{6}93.{4}.*',
    $enable_MarkVerify                  = 'true',
    $mark_VerifyUrl                     = 'http://http://192.168.0.15:8080/CSrest/rest/sales/exciseMark/status',
    $ignoreMark_VerifyErrors		    = 'true',
    $old_Tobacco	                    = 'false'
)
{
    File {
        owner => root,
        group => root,
        mode  => 0644,
    }
	
    file { "motp.ini" :
        name    => "/linuxcash/cash/conf/ncash.ini.d/motp.ini",
        content => template("stels_motp/motp.erb"),
    }
	
	file { "ncash.ini" :
		name    => "/linuxcash/cash/conf/ncash.ini",
		content => template("stels_motp/ncash.erb"),
    }
	
    file { "bcode.ini" :
        name   => "/linuxcash/cash/conf/bcode.ini",
        source => "puppet:///modules/stels_motp/bcode.ini",
    }
}
