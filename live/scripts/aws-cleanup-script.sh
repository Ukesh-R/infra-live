set -e

TABLE="ukesh-table"
NOW=$(date +%s)

echo "======================================"
echo "Starting TTL Cleanup at $SANDBOX_NAME"
echo "======================================"

aws dynamodb scan \
  --table-name "$TABLE" \
  --output json | jq -c '.Items[]' | while read -r item; do

  # Extract values from DynamoDB
  SANDBOX_NAME=$(echo "$item" | jq -r '.LockID.S')
  EXPIRES=$(echo "$item" | jq -r '.expires_at.N')
  PATH_DIR=$(echo "$item" | jq -r '.path.S')
  STATUS=$(echo "$item" | jq -r '.status.S')
  CREATED_AT=$(echo "$item" | jq -r '.created_at.N')

  TTL_SECONDS=$((EXPIRES - CREATED_AT))

  export OWNER=$SANDBOX_NAME
  export CREATED_AT=$CREATED_AT
  export TTL_SECONDS=$TTL_SECONDS

  echo "Checking sandbox: $SANDBOX_NAME | STATUS=$STATUS | EXPIRES=$EXPIRES"

  # Skip invalid entries
  if [ "$SANDBOX_NAME" = "null" ] || [ "$EXPIRES" = "null" ]; then
    echo "Skipping invalid record..."
    continue
  fi

  # Check TTL expiry
  if [ "$STATUS" = "active" ] && [ "$NOW" -gt "$EXPIRES" ]; then

    echo "TTL expired → cleaning sandbox: $SANDBOX_NAME"

    cd ~/terraform-projects/$PATH_DIR

    echo "Selecting workspace..."
    terragrunt run --all -- workspace select "$SANDBOX_NAME"

    echo "Destroying infrastructure..."
    terragrunt run --all destroy -- -auto-approve

    echo "Switching to default workspace..."
    terragrunt run --all -- workspace select default

    echo "Deleting sandbox workspace..."
    terragrunt run --all -- workspace delete "$SANDBOX_NAME"

    echo "Updating DynamoDB status..."

    aws dynamodb update-item \
      --table-name "$TABLE" \
      --key "{\"LockID\":{\"S\":\"$SANDBOX_NAME\"}}" \
      --update-expression "SET #s = :deleted" \
      --expression-attribute-names '{"#s":"status"}' \
      --expression-attribute-values '{":deleted":{"S":"deleted"}}'

    echo "✅ Sandbox $SANDBOX_NAME cleaned successfully"

  else

    echo "Sandbox $SANDBOX_NAME not expired or already deleted"

  fi

done

echo "======================================"
echo "Cleanup Finished"
echo "======================================"