class openresty::config inherits openresty::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  file { '/etc/systemd/system/openresty.service':
    ensure  => present,
    source  => 'puppet:///modules/openresty/openresty.service',
    owner   => root,
    group   => root,
    mode    => 0755,
  }
  exec { "systemctl daemon-reload":
    subscribe => File['/etc/systemd/system/openresty.service'],
    onlyif => "[ `ps aux | grep nginx | wc -l` -le 1 ]",
  }


}
