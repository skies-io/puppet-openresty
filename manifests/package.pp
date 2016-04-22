
class openresty::package inherits openresty::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package["libreadline-dev"]) { package { "libreadline-dev": ensure => installed, } }
  if ! defined(Package["libncurses5-dev"]) { package { "libncurses5-dev": ensure => installed, } }
  if ! defined(Package["libpcre3-dev"]) { package { "libpcre3-dev": ensure => installed, } }
  if ! defined(Package["libssl-dev"]) { package { "libssl-dev": ensure => installed, } }
  if ! defined(Package["make"]) { package { "make": ensure => installed, } }
    if ! defined(Package["build-essential"]) { package { "build-essential": ensure => installed, } }
  if ! defined(Package["perl"]) { package { "perl": ensure => installed, } }
  exec { 'openresty::package::install_openresty':
    cwd     => '/tmp',
    command => "wget ${openresty::params::openresty_url} -O resty.tar.gz ; tar zxf resty.tar.gz ; cd openr* ; ./configure --with-luajit --with-pcre-jit --with-ipv6 --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_addition_module --with-http_gzip_static_module --with-http_sub_module; make -j4 install",
    unless  => 'test -d /usr/local/openresty',
    require  => [ 
      Package['libreadline-dev'],
      Package['libncurses5-dev'],
      Package['libpcre3-dev'],
      Package['libssl-dev'],
      Package['build-essential'],
      Package['perl'],
    ],
  }
  exec { 'openresty::package::install_luasocket':
    cwd     => '/tmp',
    command => "wget ${openresty::params::luasocket_url} -O luasocket.tar.gz; tar zxf luasocket.tar.gz ; cd luasocket*; LUAINC=-I/usr/local/openresty/luajit/include/luajit-2.0/ make ; make install",
    unless  => 'test -d /usr/local/share/lua/5.1/socket',
    require => Exec['openresty::package::install_openresty'],
  }

}
