set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./create-openstack-sandbox.sh <owner> <ttl_days>"
  exit 1
fi

OWNER=$1
TTL=$2
ID=$(date +%Y%m%d-%H%M%S)

BASE_DIR="../ephemeral/openstack-sandbox"
TEMPLATE_DIR="$BASE_DIR/template"
REQUESTS_DIR="$BASE_DIR/requests"

SANDBOX_NAME="${OWNER}-${ID}"
SANDBOX_DIR="$REQUESTS_DIR/$SANDBOX_NAME"

echo "Creating OpenStack sandbox for $OWNER with TTL $TTL days..."

mkdir -p "$SANDBOX_DIR"

cp -r "$TEMPLATE_DIR/"* "$SANDBOX_DIR/"

CREATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat <<EOF > "$SANDBOX_DIR/inputs.hcl"
inputs = {

  owner      = "$OWNER"
  ttl_days   = $TTL
  created_at = "$CREATED_AT"

  tags = {
    Owner     = "$OWNER"
    TTL       = "$TTL"
    CreatedAt = "$CREATED_AT"
  }

}
EOF

cd "$SANDBOX_DIR"

echo "Running Terragrunt..."

terragrunt init
terragrunt run --all apply --auto-approve



REQUEST_ID="$SANDBOX_NAME"

PATH_VALUE="/infra-live/ephemeral/openstack-sandbox/requests/$SANDBOX_NAME"

echo "Registering sandbox in DynamoDB..."

aws dynamodb put-item \
  --table-name ephemeral-infra \
  --item "{
    \"request_id\": {\"S\": \"$REQUEST_ID\"},
    \"owner\": {\"S\": \"$OWNER\"},
    \"created_at\": {\"S\": \"$CREATED_AT\"},
    \"ttl_days\": {\"N\": \"$TTL\"},
    \"path\": {\"S\": \"$PATH_VALUE\"},
    \"status\": {\"S\": \"active\"},
    \"cloud\": {\"S\": \"openstack\"}
  }"


echo "OpenStack sandbox successfully created!"

echo "Sandbox Name: $SANDBOX_NAME"
