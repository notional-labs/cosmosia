pacman -Syu --noconfirm
pacman -S --noconfirm base-devel wget dnsutils nginx cronie screen logrotate

########################################################################################################################
# SSL for notional.ventures (fullchain.pem and privkey.pem files)
wget "http://tasks.web_config/config/fullchain.pem" -O /etc/nginx/fullchain.pem
wget "http://tasks.web_config/config/privkey.pem" -O /etc/nginx/privkey.pem

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy_custom/interchain/nginx.conf > /etc/nginx/nginx.conf

# get tokens
wget "http://tasks.web_config/configinterchain_proxy_secret_tokens.txt" -O $HOME/secret_tokens.txt

TOKENS=$(cat $HOME/secret_tokens.txt)
COUNTER=0
for token in $TOKENS; do
  eval "token_${COUNTER}=\"$token"\"
  COUNTER=$(( COUNTER + 1 ))
done

# generate endpoints.conf
SERVICES="juno osmosis cosmoshub chihuahua terra2 stargaze axelar gravitybridge injective kujira"

echo "" > /etc/nginx/endpoints.conf

HEADER_CORS=$(cat <<-END
        proxy_hide_header 'Access-Control-Allow-Origin';
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Credentials' 'true';
        add_header 'Access-Control-Allow-Headers' 'Authorization,Accept,Origin,DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range';
        add_header 'Access-Control-Allow-Methods' 'GET,POST,OPTIONS,PUT,DELETE,PATCH';
END
)

HEADER_OPTIONS=$(cat <<-END
            if (\$request_method = 'OPTIONS') {
                add_header 'Access-Control-Allow-Origin' '*';
                add_header 'Access-Control-Allow-Credentials' 'true';
                add_header 'Access-Control-Allow-Headers' 'Authorization,Accept,Origin,DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range';
                add_header 'Access-Control-Allow-Methods' 'GET,POST,OPTIONS,PUT,DELETE,PATCH';

                add_header 'Access-Control-Max-Age' 1728000;
                add_header 'Content-Type' 'text/plain; charset=utf-8';
                add_header 'Content-Length' 0;
                return 204;
            }
END
)

HEADER_WS=$(cat <<-END
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header Host \$http_host;
            proxy_set_header X-NginX-Proxy true;
END
)

COUNTER=0
for service_name in $SERVICES; do
  varname="token_$COUNTER"
  service_with_token="$service_name-${!varname}"

  cat <<EOT >> /etc/nginx/endpoints.conf
    # RPC
    server {
        listen 443 ssl http2;
        server_name rpc-${service_with_token}-ie.interchain.notional.ventures;
        $HEADER_CORS
        location ~* ^/(.*) {
            $HEADER_OPTIONS
            $HEADER_WS
            proxy_pass http://backend_rpc_${service_name}/\$1\$is_args\$args;
        }
    }
EOT
  COUNTER=$(( COUNTER + 1 ))
  varname="token_$COUNTER"
  service_with_token="$service_name-${!varname}"

  cat <<EOT >> /etc/nginx/endpoints.conf
    # REST/API
    server {
        listen 443 ssl http2;
        server_name api-${service_with_token}-ie.interchain.notional.ventures;
        $HEADER_CORS
        location ~* ^/(.*) {
            $HEADER_OPTIONS
            $HEADER_WS
            proxy_pass http://backend_api_${service_name}/\$1\$is_args\$args;
        }
    }
EOT
  COUNTER=$(( COUNTER + 1 ))
  varname="token_$COUNTER"
  service_with_token="$service_name-${!varname}"

  cat <<EOT >> /etc/nginx/endpoints.conf
    # gRPC
    server {
        listen 443 ssl http2;
        server_name grpc-${service_with_token}-ie.interchain.notional.ventures;

        location / {
            grpc_pass grpc://backend_grpc_${service_name};
        }
    }
EOT

  COUNTER=$(( COUNTER + 1 ))
done

# generate for jsonrpc start from COUNTER 250
COUNTER=250
SERVICES_JSONRPC="evmos evmos-testnet-archive evmos-archive"

for service_name in $SERVICES_JSONRPC; do
  varname="token_$COUNTER"
  service_with_token="$service_name-${!varname}"

  cat <<EOT >> /etc/nginx/endpoints.conf
    # JSON-RPC
    server {
        listen 443 ssl http2;
        server_name jsonrpc-${service_with_token}-ie.interchain.notional.ventures;
        $HEADER_CORS

        # WS-JSON-RPC
        location ~* ^/websocket/(.*) {
            $HEADER_OPTIONS
            $HEADER_WS

            # fix Disconnected code 1006
            proxy_read_timeout 86400;
            proxy_send_timeout 86400;
            keepalive_timeout  86400;

            proxy_pass http://backend_wsjsonrpc_${service_name}/\$1\$is_args\$args;
        }

        location ~* ^/(.*) {
            $HEADER_OPTIONS
            proxy_pass http://backend_jsonrpc_${service_name}/\$1\$is_args\$args;
        }
    }
EOT
  COUNTER=$(( COUNTER + 1 ))
done

########################################################################################################################

# generate config for the first time
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy_custom/interchain/generate_upstream.sh" > $HOME/generate_upstream.sh
sleep 1
source $HOME/generate_upstream.sh
echo "UPSTREAM_CONFIG_FILE=$UPSTREAM_CONFIG_FILE"
echo "UPSTREAM_CONFIG_FILE_TMP=$UPSTREAM_CONFIG_FILE_TMP"
sleep 1
cat "$UPSTREAM_CONFIG_FILE_TMP" > "$UPSTREAM_CONFIG_FILE"
sleep 1

# run nginx with screen to avoid log to docker
screen -S nginx -dm /usr/sbin/nginx -g "daemon off;"

########################################################################################################################
# logrotate
sed -i -e "s/{.*/{\n\tdaily\n\trotate 2/" /etc/logrotate.d/nginx
sed -i -e "s/create.*/create 0644 root root/" /etc/logrotate.d/nginx

echo "0 0 * * * root logrotate /etc/logrotate.d/nginx" > /etc/cron.d/cron_logrotate

########################################################################################################################
# cron
cat <<'EOT' >  $HOME/cron_update_upstream.sh
source $HOME/generate_upstream.sh
sleep 1

if cmp -s "$UPSTREAM_CONFIG_FILE" "$UPSTREAM_CONFIG_FILE_TMP"; then
  # the same => do nothing
  echo "no config change, do nothing..."
else
  # different

  # show the diff
  diff -c "$UPSTREAM_CONFIG_FILE" "$UPSTREAM_CONFIG_FILE_TMP"

  echo "found config changes, updating..."
  cat "$UPSTREAM_CONFIG_FILE_TMP" > "$UPSTREAM_CONFIG_FILE"
  sleep 1
  /usr/sbin/nginx -s reload
fi
EOT

sleep 1
echo "*/5 * * * * root /bin/bash $HOME/cron_update_upstream.sh" > /etc/cron.d/cron_update_upstream
sleep 1
crond

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
