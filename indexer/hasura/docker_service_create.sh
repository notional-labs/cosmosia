# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh juno

chain_name="$1"

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./docker_service_create.sh juno"
  exit
fi

SERVICE_NAME="hasura_${chain_name}"

# delete existing service
docker service rm $SERVICE_NAME


# get hasura_graphql_admin_secret from docker swarm
hasura_graphql_admin_secret=$(docker config inspect hasura_graphql_admin_secret.txt |jq -r '.[0].Spec.Data' |base64 --decode)

if [[ -z $hasura_graphql_admin_secret ]]; then
  echo "No hasura_graphql_admin_secret, Pls set password to docker config named hasura_graphql_admin_secret.txt and try again!"
  exit
fi


docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --restart-condition none \
  --env HASURA_GRAPHQL_METADATA_DATABASE_URL=postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/hasura \
  --env HASURA_GRAPHQL_DATABASE_URL=postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno \
  --env PG_DATABASE_URL=postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno \
  --env HASURA_GRAPHQL_ENABLE_CONSOLE=true \
  --env HASURA_GRAPHQL_DEV_MODE=false \
  --env HASURA_GRAPHQL_ENABLED_LOG_TYPES=startup \
  --env HASURA_GRAPHQL_ADMIN_SECRET=${hasura_graphql_admin_secret} \
  --env HASURA_GRAPHQL_UNAUTHORIZED_ROLE=anonymous \
  --env ACTION_BASE_URL=http://localhost:3000 \
  hasura/graphql-engine:v2.11.1