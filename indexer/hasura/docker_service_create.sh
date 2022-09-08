
SERVICE_NAME="hasura_juno"

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --restart-condition none \
  --env HASURA_GRAPHQL_METADATA_DATABASE_URL=postgresql://postgres:mysecretpassword@tasks.psql_juno:5432/hasura \
  --env HASURA_GRAPHQL_DATABASE_URL=postgresql://postgres:mysecretpassword@tasks.psql_juno:5432/bdjuno \
  --env PG_DATABASE_URL=postgresql://postgres:mysecretpassword@tasks.psql_juno:5432/bdjuno \
  --env HASURA_GRAPHQL_ENABLE_CONSOLE=true \
  --env HASURA_GRAPHQL_DEV_MODE=false \
  --env HASURA_GRAPHQL_ENABLED_LOG_TYPES=startup \
  --env HASURA_GRAPHQL_ADMIN_SECRET=myadminsecretkey \
  --env HASURA_GRAPHQL_UNAUTHORIZED_ROLE=anonymous \
  --env ACTION_BASE_URL=http://localhost:3000 \
  hasura/graphql-engine:v2.11.1