cd $HOME

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

cd $HOME

pacman -Syu --noconfirm
pacman -Sy --noconfirm base-devel wget jq dnsutils inetutils openssh screen
pacman -Syu --noconfirm

# sshkey
mkdir -p $HOME/.ssh
curl -Ls http://tasks.web_config/config/cosmosia.id_rsa.pub > $HOME/.ssh/id_rsa.pub
curl -Ls http://tasks.web_config/config/cosmosia.id_rsa > $HOME/.ssh/id_rsa
chmod -R 700 ~/.ssh

# generate ssh keys
ssh-keygen -A

# append cosmosia pubkey to authorized_keys
curl -Ls http://tasks.web_config/config/cosmosia.id_rsa.pub > $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

# start sshd
screen -S sshd -dm /usr/bin/sshd -D

loop_forever