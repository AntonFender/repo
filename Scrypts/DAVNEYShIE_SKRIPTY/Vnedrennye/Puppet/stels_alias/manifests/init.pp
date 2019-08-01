class stels_alias (
)
{
	File {
		owner => 'root',
		group => 'root',
		mode  => '0644',
	}
	
	file { "bash_aliases" :
    		name   => "/root/.bash_aliases",
    		source => "puppet:///modules/stels_alias/.bash_aliases",
    }
		
}