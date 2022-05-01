pacman -Syu --noconfirm
pacman -S --noconfirm base-devel screen prometheus grafana

cd $HOME

############
# prometheus
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/grafana/prometheus.yaml > ~/prometheus.yaml
screen -S prometheus -dm /usr/sbin/prometheus --config.file=$HOME/prometheus.yaml

#################
# grafana server
mkdir -p /var/lib/grafana/conf/provisioning/datasources
mkdir -p /var/lib/grafana/conf/provisioning/dashboards
mkdir -p /var/lib/grafana/dashboards
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/grafana/datasources.yaml > /var/lib/grafana/conf/provisioning/datasources/datasources.yaml
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/grafana/dashboards.yaml > /var/lib/grafana/conf/provisioning/dashboards/dashboards.yaml
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/grafana/MyDashboard.json > /var/lib/grafana/dashboards/MyDashboard.json

screen -S grafana -dm /usr/sbin/grafana-server -homepath /usr/share/grafana


# loop forever for debugging
while true; do sleep 5; done