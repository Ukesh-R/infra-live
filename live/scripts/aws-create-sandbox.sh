set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./create-sandbox.sh <owner> <ttl_days>"
  exit 1
fi

OWNER=$1
TTL=$2
ID=$(date +%Y%m%d-%H%M%S)

BASE_DIR="../ephemeral/sandbox"
TEMPLATE_DIR="$BASE_DIR/template"
REQUESTS_DIR="$BASE_DIR/requests"
SANDBOX_DIR="$REQUESTS_DIR/${OWNER}-${ID}"

echo "Creating sandbox for $OWNER with TTL $TTL days..."

mkdir -p "$SANDBOX_DIR"

cp -r "$TEMPLATE_DIR/"* "$SANDBOX_DIR/"

cat <<EOF > "$SANDBOX_DIR/inputs.hcl"
inputs = {
  owner      = "$OWNER"
  ttl_days   = $TTL
  created_at = "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  tags = {
    Owner     = "$OWNER"
    TTL       = "$TTL"
    CreatedAt = "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  }
}
EOF

cd "$SANDBOX_DIR"

terragrunt init
terragrunt apply -auto-approve


CREATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
REQUEST_ID="${OWNER}-${ID}"
PATH_VALUE="/infra-live/ephemeral/sandbox/requests/${OWNER}-${ID}"

echo "Registering sandbox in DynamoDB..."

if aws dynamodb put-item \
  --table-name ephemeral-infra \
  --item "{
    \"request_id\": {\"S\": \"${REQUEST_ID}\"},
    \"owner\": {\"S\": \"${OWNER}\"},
    \"created_at\": {\"S\": \"${CREATED_AT}\"},
    \"ttl_days\": {\"N\": \"${TTL}\"},
    \"path\": {\"S\": \"${PATH_VALUE}\"},
    \"status\": {\"S\": \"active\"}
  }"
then
  echo "Sandbox successfully created and registered in DynamoDB"
else
  echo "ERROR: Infra created but failed to register metadata."
  exit 1
fi



