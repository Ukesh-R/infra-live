set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./aws-create-sandbox.sh <sandbox_name> <ttl_seconds>"
  exit 1
fi

SANDBOX_NAME=$1
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

CURRENT_TIME=$(date +%s)
EXPIRES_AT=$((CURRENT_TIME + TTL))

cat <<EOF > "$SANDBOX_DIR/inputs.hcl"
inputs = {
  owner       = "$SANDBOX_NAME"
  ttl_seconds = $TTL
  created_at  = "$CURRENT_TIME"

  tags = {
    owner       = "$SANDBOX_NAME"
    ttl_seconds = "$TTL"
    created_at  = "$CURRENT_TIME"
  }
}
EOF

export OWNER=$SANDBOX_NAME
export TTL_SECONDS=$TTL
export CREATED_AT=$CURRENT_TIME

cd "$SANDBOX_DIR"

echo "Initializing infrastructure..."

# terragrunt run --all init

echo "Creating/selecting workspace..."

terragrunt run --all -- workspace select -or-create $SANDBOX_NAME

echo "Applying infrastructure..."

terragrunt run --all apply -- -auto-approve

CREATED_AT_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

aws dynamodb put-item \
  --table-name ukesh-table \
  --item "{
    \"LockID\": {\"S\": \"${SANDBOX_NAME}\"},
    \"owner\": {\"S\": \"${SANDBOX_NAME}\"},
    \"created_at\": {\"N\": \"${CURRENT_TIME}\"},
    \"expires_at\": {\"N\": \"${EXPIRES_AT}\"},
    \"path\": {\"S\": \"live/ephemeral/sandbox/requests/${SANDBOX_NAME}\"},
    \"status\": {\"S\": \"active\"}
  }"

echo "======================================"
echo "Sandbox Created Successfully!"
echo "Sandbox Name: $SANDBOX_NAME"
echo "======================================"