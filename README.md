# puppet-openresty

A puppet module to handle openresty configuration and installation

## Usage

Basic

`include openresty`

Upstream  

```ruby
  openresty::upstream {"phpfastcgi":
    ensure  => present,
    members => [
                '127.0.0.1:9000',
                ],
    notify => Service['openresty'],
  }
```

Advanced Site
```ruby
  openresty::site {"mywebsite.io":
    ensure => enable,
    listen_port => '80',
    gzip => 'yes',
    server_name => ["mywebsite.io"],
    ssl => 'no',
    log_access => "/space/log/access.log",
    log_error => "/space/log/error.log",
    root => "/space/mywebsite/public/",
    locations => {
      '~ \.php$' => {
        'root' => "/space/mywebsite/public/",
        "include" => "/usr/local/openresty/nginx/conf/fastcgi.conf",
        'custom_params' => {
          "access_log" => "/space/log/upstream.log  upstream",
          "fastcgi_pass" => "phpfastcgi",
        }
      },
      '/' => {
        'root' => "/space/mywebsite/public/",
        "need_auth" => "true",
        "auth_basic" => "authentication",
        "auth_basic_user_file" => "/space/auth.conf",
        'index' => "index.php",
        'custom_params' => {
          "try_files" => '$uri $uri/ /index.php$is_args$args',
          "satisfy" => "any",
          "access_by_lua" => "'
                          local uri = ngx.var.request_uri
                          local redis = require \"resty.redis\"
                          local red = redis:new()

                          red:set_timeout(1000)

                          local ok, err = red:connect(\"127.0.0.1\", 6379)
                          if not ok then
                              ngx.log(ngx.ERR, \"Failed to connect to Redis: \", err)
                              return ngx.exit(500)
                          end
                      '",
        }
      },
    },
    require => [File["/space/mywebsite"]],
  }
```
