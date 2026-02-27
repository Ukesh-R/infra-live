set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./aws-create-sandbox.sh <sandbox_name> <ttl_seconds>"
  exit 1
fi

SANDBOX_NAME=$1
export TG_WORKSPACE=$SANDBOX_NAME
TTL=$2


BASE_DIR="../ephemeral/sandbox"
TEMPLATE_DIR="$BASE_DIR/template/dev"
REQUESTS_DIR="$BASE_DIR/requests"

SANDBOX_DIR="$REQUESTS_DIR/$SANDBOX_NAME"

echo "======================================"
echo "Creating sandbox: $SANDBOX_NAME"
echo "TTL: $TTL SECONDS"
echo "======================================"

mkdir -p "$SANDBOX_DIR"

cp -r "$TEMPLATE_DIR/"* "$SANDBOX_DIR/"

cat <<EOF > "$SANDBOX_DIR/inputs.hcl"
inputs = {
  owner       = "$SANDBOX_NAME"
  ttl_seconds = $TTL
  created_at  = "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  tags = {
    Owner = "$SANDBOX_NAME"
    TTL   = "$TTL"
  }
}
EOF

export OWNER=$SANDBOX_NAME
export TTL_SECONDS=$TTL
export CREATED_AT=$(date +%s)


cd "$SANDBOX_DIR"
export TG_WORKSPACE=$SANDBOX_NAME
echo "Creating workspace..."
terragrunt run --all workspace new $SANDBOX_NAME || true
terragrunt run --all workspace select $SANDBOX_NAME
echo "Initializing infrastructure..."
terragrunt run --all init
echo "Applying infrastructure..."
terragrunt run --all apply -- -auto-approve
CREATED_AT_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")


aws dynamodb put-item \
  --table-name ukesh-table \
  --item "{
    \"request_id\": {\"S\": \"${SANDBOX_NAME}\"},
    \"owner\": {\"S\": \"${SANDBOX_NAME}\"},
    \"created_at\": {\"S\": \"${CREATED_AT_ISO}\"},
    \"ttl_seconds\": {\"N\": \"${TTL}\"},
    \"path\": {\"S\": \"/infra-live/ephemeral/sandbox/requests/${SANDBOX_NAME}\"},
    \"status\": {\"S\": \"active\"}
  }"


echo "======================================"
echo "Sandbox Created Successfully!"
echo "Sandbox Name: $SANDBOX_NAME"
echo "======================================"