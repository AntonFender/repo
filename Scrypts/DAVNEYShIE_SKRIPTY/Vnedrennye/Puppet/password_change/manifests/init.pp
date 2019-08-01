class password_change (
)
{
  exec { "ChangePass":
        path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
        command     => "/usr/bin/echo -e "gbplfnsqgfhjkm\gbplfnsqgfhjkm\n" | passwd",
        refreshonly => true,
        logoutput   => true,
    } 
}


