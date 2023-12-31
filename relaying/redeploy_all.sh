SERVICES=$(cat <<-END
test
furya
coreum
whitewhale
sei
seilegacy
kava
composable
osmosis
injective
END
)

for service_name in $SERVICES; do
  echo "redeploying $service_name"
  sh docker_service_create.sh $service_name
  sleep 3
done

