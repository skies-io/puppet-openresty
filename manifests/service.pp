class openresty::service {
  service { 'openresty':
    provider => 'systemd',
    ensure   => running,
  }
}
