pacman -Syu --noconfirm
pacman -S --noconfirm screen

cd $HOME

############
# prometheus
echo "Installing prometheus..."
pacman -S --noconfirm prometheus

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/grafana-relayer/prometheus.yaml > $HOME/prometheus.yaml

# run prometheus
screen -S prometheus -dm /usr/sbin/prometheus --config.file=$HOME/prometheus.yaml

#################
# grafana server
echo "Intalling grafana..."
pacman -S --noconfirm grafana

mkdir -p /var/lib/grafana/conf/provisioning/datasources
mkdir -p /var/lib/grafana/conf/provisioning/dashboards
mkdir -p /var/lib/grafana/dashboards
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/grafana-relayer/datasource.yaml > /var/lib/grafana/conf/provisioning/datasources/datasource.yaml
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/grafana-relayer/dashboard.yaml > /var/lib/grafana/conf/provisioning/dashboards/dashboard.yaml
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/grafana-relayer/MyDashboard.json > /var/lib/grafana/dashboards/MyDashboard.json

# change admin password
default_password="$(curl -s "http://tasks.web_config/config/GRAFANA_PASSWORD")"
if [[ $default_password != "NOT_FOUND" ]]; then
  sed -i -e "s/^admin_password *=.*/admin_password = $default_password/" /usr/share/grafana/conf/defaults.ini
fi

screen -S grafana -dm /usr/sbin/grafana-server -homepath /usr/share/grafana

########################################################################################################################
echo "Done!"
# loop forever for debugging
while true; do sleep 5; done