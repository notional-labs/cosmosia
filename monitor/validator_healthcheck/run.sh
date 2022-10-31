pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel wget dnsutils python python-pip screen

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/cosmosia

########################################################################################################################
# validator_healthcheck api
cd $HOME/cosmosia/monitor/validator_healthcheck/api
pip install -r requirements.txt
screen -S api -dm /usr/sbin/python app.py

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
