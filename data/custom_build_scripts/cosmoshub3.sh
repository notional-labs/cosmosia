cd $HOME

BINARY_URL="http://95.216.19.36:11111/cosmoshub3-archive-sub0/releases/v2.0.3/gaiad"
BINARY_PATH="${HOME}/go/bin/gaiad"

wget "${BINARY_URL}" -O "${BINARY_PATH}"
chmod +x "${BINARY_PATH}"
