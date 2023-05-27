pacman -Syu --noconfirm
pacman -S --noconfirm base-devel jq dnsutils git yarn cronie screen python


# install nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v18.14.0

yarn set version v18.14.0

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/cosmosia

########################################################################################################################
# web
cd $HOME/cosmosia/admin/web

# create .env.local file
cat <<EOT >> .env.local
NEXTAUTH_URL="$COSMOSIA_ADMIN_NEXTAUTH_URL"
NEXTAUTH_SECRET="$COSMOSIA_ADMIN_NEXTAUTH_SECRET"
ADMIN_PASSWORD="$COSMOSIA_ADMIN_PASSWORD"
CHAIN_REGISTRY_INI_URL="$CHAIN_REGISTRY_INI_URL"
EOT


yarn && yarn build

screen -S server -dm yarn start

########################################################################################################################
# cron
echo "*/1 * * * * root /bin/bash $HOME/cosmosia/admin/cronjob_get_status.sh" > /etc/cron.d/cron_get_status
echo "*/5 * * * * root /bin/bash $HOME/cosmosia/admin/cronjob_get_snapshot_size.sh" > /etc/cron.d/cron_get_snapshot_size

# start crond
crond

# loop forever for debugging only
while true; do sleep 5; done
