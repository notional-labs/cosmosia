SERVICES=$(cat <<-END
composable
coreum
furya
injective
kava
test
whitewhale
END
)

for service_name in $SERVICES; do
  echo "redeploying $service_name"
  sh docker_service_create.sh $service_name
  sleep 3
done

