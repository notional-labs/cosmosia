cd $HOME

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

pacman -Syu --noconfirm
pacman -Sy --noconfirm base-devel wget jq dnsutils inetutils openssh
pacman -Syu --noconfirm



loop_forever