class changepassword (
)
{
   exec { "changePass":
       path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
       command     => "echo -e "gbplfnsqgfhjkm\gbplfnsqgfhjkm\n" | passwd",
	   refreshonly => true,
       logoutput   => true,
   }
}


