#!/bin/bash

TABLE="ukesh-table"
NOW=$(date +%s)

aws dynamodb scan \
  --table-name $TABLE \
  --output json | jq -c '.Items[]' | while read item; do

OWNER=$(echo $item | jq -r '.owner.S')
EXPIRES=$(echo $item | jq -r '.expires_at.N')
PATH_DIR=$(echo $item | jq -r '.path.S')
STATUS=$(echo $item | jq -r '.status.S')

if [ "$STATUS" = "active" ] && [ "$NOW" -gt "$EXPIRES" ]; then

echo "TTL expired → destroying $OWNER"

cd ~/terraform-projects/$PATH_DIR

export OWNER=$OWNER
export TTL_SECONDS=0
export CREATED_AT=0

terragrunt run --all destroy -- -auto-approve

terragrunt run --all -- workspace select default

terragrunt run --all -- workspace delete $OWNER

aws dynamodb update-item \
  --table-name $TABLE \
  --key "{\"LockID\":{\"S\":\"$OWNER\"}}" \
  --update-expression "SET #s = :deleted" \
  --expression-attribute-names '{"#s":"status"}' \
  --expression-attribute-values '{":deleted":{"S":"deleted"}}'

echo "$OWNER deleted successfully"

fi

done