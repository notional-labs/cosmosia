pacman -Syu --noconfirm
pacman -S --noconfirm wget unzip screen

cd $HOME

########################################################################################################################
# install loki
cd $HOME
curl -O -L "https://github.com/grafana/loki/releases/download/v2.8.7/loki-linux-amd64.zip"
unzip "loki-linux-amd64.zip"
chmod a+x "loki-linux-amd64"
rm "loki-linux-amd64.zip"

# install promtail
cd $HOME
curl -O -L "https://github.com/grafana/loki/releases/download/v2.8.7/promtail-linux-amd64.zip"
unzip "promtail-linux-amd64.zip"
chmod a+x "promtail-linux-amd64"
rm "promtail-linux-amd64.zip"

# download configs
cd $HOME
wget "https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/loki/config.yaml"
wget "https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/loki/promtail_config.yaml"

# run loki
screen -S loki -dm $HOME/loki-linux-amd64 -config.file=$HOME/config.yaml

# run promtail
screen -S promtail -dm $HOME/promtail-linux-amd64 -config.file=$HOME/promtail_config.yaml


###############################################################f#########################################################
echo "Done!"
# loop forever for debugging
while true; do sleep 5; done