#  nginx::upstream { 'phpfastcgi':
#    ensure  => present,
#    members => [
#      'localhost:3000',
#      'localhost:3001',
#      'localhost:3002',
#    ],
#  }

define openresty::upstream (
  $ensure = 'present',
  $members,
) {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { "/usr/local/openresty/nginx/conf/conf.d/${name}-upstream.cnf":
    ensure   => $ensure ? {
      'absent' => absent,
      default  => 'file',
    },
    content  => template('openresty/upstream.conf.erb'),
    notify   => Service['openresty'],
  }

}
