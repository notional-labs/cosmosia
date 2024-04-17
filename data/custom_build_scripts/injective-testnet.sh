cd $HOME

if [[ -z $upgrading ]]; then
  pacman -Sy --noconfirm unzip
  wget "https://github.com/InjectiveLabs/testnet/releases/download/${version}/linux-amd64.zip"
  unzip linux-amd64.zip
  mv injectived peggo $HOME/go/bin
  mv libwasmvm.x86_64.so /usr/lib
  rm linux-amd64.zip
else
  wget "https://github.com/InjectiveLabs/testnet/releases/download/${$p_version}/linux-amd64.zip"
  unzip linux-amd64.zip
  mv injectived peggo $HOME/go/bin
  mv libwasmvm.x86_64.so /usr/lib
  rm linux-amd64.zip
fi
