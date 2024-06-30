SERVICES=$(cat <<-END
composable
coreum
furya
injective
kava
quicksilver
test
whitewhale
whitewhale-testnet
END
)

for service_name in $SERVICES; do
  echo "redeploying $service_name"
  sh docker_service_create.sh $service_name
  sleep 3
done

