define openresty::redirect (
       $listen_port = '443',
       $server_name = $name,
       $to_addr,
) {
  file {"redirect-${name}.conf":
     path => "/usr/local/openresty/nginx/conf/sites/redirect-${name}.conf",
     ensure => present,
     purge => true,
     content => template('openresty/redirect.conf.erb'),
     notify => Service['openresty'],
  }
}
