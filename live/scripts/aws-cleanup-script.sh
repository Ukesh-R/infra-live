set -e

TABLE="ukesh-table"
BUCKET="ukesh-s3-bucket-12"

NOW=$(date +%s)

echo "======================================"
echo "Starting TTL Cleanup at $NOW"
echo "======================================"

ORIGINAL_DIR=$(pwd)

aws dynamodb scan \
  --table-name "$TABLE" \
  --output json | jq -c '.Items[]' | while read -r item; do

  SANDBOX_NAME=$(echo "$item" | jq -r '.LockID.S')
  EXPIRES=$(echo "$item" | jq -r '.expires_at.N')
  PATH_DIR=$(echo "$item" | jq -r '.path.S')
  CREATED_AT=$(echo "$item" | jq -r '.created_at.N')

  TTL_SECONDS=$((EXPIRES - CREATED_AT))

  export OWNER=$SANDBOX_NAME
  export CREATED_AT=$CREATED_AT
  export TTL_SECONDS=$TTL_SECONDS

  echo "Checking sandbox: $SANDBOX_NAME | EXPIRES=$EXPIRES"

  if [ "$NOW" -gt "$EXPIRES" ]; then

    echo "Cleaning sandbox: $SANDBOX_NAME"

    cd ~/terraform-projects/$PATH_DIR

    echo "Selecting workspace..."
    terragrunt run --all workspace select "$SANDBOX_NAME"

    echo "Destroying infrastructure..."
    terragrunt run --all destroy \
      --non-interactive \
      -- -auto-approve

    echo "Switching to default workspace..."
    terragrunt run --all workspace select default

    echo "Deleting workspace..."
    terragrunt run --all workspace delete \
      --non-interactive \
      -- -force "$SANDBOX_NAME"


    echo "Deleting S3 state..."
    aws s3 rm s3://$BUCKET/env:/$SANDBOX_NAME --recursive

    echo "Deleting DynamoDB record..."
    aws dynamodb delete-item \
      --table-name "$TABLE" \
      --key "{\"LockID\":{\"S\":\"$SANDBOX_NAME\"}}"

    echo "Deleting local folder..."
    rm -rf ~/terraform-projects/$PATH_DIR

    cd "$ORIGINAL_DIR"

    echo "Sandbox deleted: $SANDBOX_NAME"

  fi

done

echo "======================================"
echo "Cleanup Finished"
echo "======================================"