define openresty::site (
	$ensure		      = 'enable',
	$listen_ip	      = '*',
	$listen_port            = '80',
	$ssl                    = false,
	$ssl_cert               = undef,
	$ssl_key                = undef,
	$ssl_port		      = '443',
	$index_files            = ['index.html', 'index.htm', 'index.php'],
	$server_name            = [$name],
	$www_root               = undef,
	$log_access	      = "/var/log/access.log",
	$log_error	      = "/var/log/error.log",
	$custom_access_log = undef,
	$rewrite_http_to_https  = undef,
	$nginx_status	      = undef,
	$nginx_status_allow     = ["127.0.0.1"],
	$location_on_50x	      =	"/home/public/nginx-default",
	$gzip		      = yes,
	$locations,
	$root = false,
) {

	if ($ssl == 'true') {
		if ($ssl_cert == undef) or ($ssl_key == undef) {
			fail('nginx: SSL certificate/key and/or SSL Private must be defined and exist')
		}
	}

	if ($ssl == 'true') and ($ssl_port == $listen_port) {
		$ssl_only = 'true'
	}

	file {"site-${name}.conf":
		path => "/usr/local/openresty/nginx/conf/sites/site-${name}.conf",
		ensure => present,
		purge => true,
		content => template('openresty/site.conf.erb'),
		notify => Service['openresty'],
	}
}
