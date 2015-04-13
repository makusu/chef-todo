server {
    listen 80;
    server_name api-todo.maxmeidendasuki.com;

    root /var/www/api-todo/web;
    error_log /var/log/nginx/api-todo.maxmeidendasuki.error.log;
    access_log /var/log/nginx/api-todo.maxmeidendasuki.access.log;

    rewrite ^/index\.php/?(.*)$ /$1 permanent;

    location / {
        index index.php;
        try_files $uri @rewriteapp;
    }

    location @rewriteapp {
        rewrite ^(.*)$ /index.php/$1 last;
    }

    location ~ ^/index\.php(/|$) {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_param  TODO_ENV "prod";
    }
}
