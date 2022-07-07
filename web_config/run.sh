pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel python python-pip nginx screen

################################################################################
# web_config
cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/cosmosia
cd $HOME/cosmosia/web_config
pip install requirements.txt

screen -S web_config -dm /usr/sbin/python app.py

sleep 3

################################################################################
# nginx

chmod 666 /var/run/docker.sock

cat <<EOT > /etc/nginx/nginx.conf
worker_processes  1;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    #tcp_nopush     on;
    #keepalive_timeout  0;
    keepalive_timeout  65;
    #gzip  on;

    # fix: could not build optimal types_hash, you should increase either types_hash_max_size: 1024 or types_hash_bucket_size: 64; ignoring types_hash_bucket_size
    types_hash_max_size 4096;
    server_names_hash_bucket_size 128;

    resolver 127.0.0.11  valid=30s;   # Docker's DNS server

    server {
        listen       80;
        server_name  localhost;
        #charset koi8-r;

        #access_log  logs/host.access.log  main;
        root   /usr/share/nginx/html;

        # location / {
        #    root /data/web_config;
        #    autoindex on;
        # }

        location ~* ^/(.*) {
            proxy_pass http://127.0.0.1:5001/$1$is_args$args;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
    }

    server {
        listen 2375;
        location / {
            proxy_pass http://unix:/var/run/docker.sock:/;
        }
    }
}
EOT


/usr/sbin/nginx -g "daemon off;"

# loop forever for debugging only
while true; do sleep 5; done