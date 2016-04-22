class openresty (
  $https = true,
  $user = "nobody nogroup",
  $worker_processes = "1",
  $worker_connections = "2048",
  $worker_rlimit = "8192",
  $keepalive_timeout = "15",
  $port = "80",
  $gzip = undef,
  $client_max_body_size = "10M",
) inherits openresty::params {
  class { 'openresty::package': }
  class { 'openresty::config':
    require => Class['openresty::package'],
  }
  class { 'openresty::service':
    require => [ Class['openresty::config'], Class['openresty::package'] ],
  }

  file {'fastcgi.conf':
    ensure => file,
    path => '/usr/local/openresty/nginx/conf/fastcgi.conf',
    content => template('openresty/fastcgi.conf.erb'),
    require => Class['openresty::package'];
  'nginx.conf':
    ensure => file,
    path => '/usr/local/openresty/nginx/conf/nginx.conf',
    content => template('openresty/nginx.conf.erb'),
    require => Class['openresty::package'];
  'sites':
    ensure => directory,
    purge => true,
    recurse => true,
    path => '/usr/local/openresty/nginx/conf/sites',
    require => Class['openresty::package'];
  'conf.d':
    ensure => directory,
    purge => true,
    path => '/usr/local/openresty/nginx/conf/conf.d',
    require => Class['openresty::package'];
  }

}
