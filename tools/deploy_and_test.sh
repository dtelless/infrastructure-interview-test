#!/bin/bash
set -e

# Configuration
TEST_DIR="tools"
INFRA_DIR="infraestructure/terraform"
INGRESS_FILE="infraestructure/k8s/ingress.yaml"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 1. Check Dependencies
log "Checking dependencies..."
for cmd in terraform kind kubectl k6 curl jq; do
    if ! command -v $cmd &> /dev/null; then
        error "$cmd is not installed."
    fi
done

# Check cloud-provider-kind process
if ! pgrep -f "cloud-provider-kind" > /dev/null; then
    log "cloud-provider-kind process not found. Starting it..."
    if command -v cloud-provider-kind &> /dev/null; then
        cloud-provider-kind &
        sleep 2
        log "cloud-provider-kind started in background."
    else
        warn "cloud-provider-kind binary not found! LoadBalancer IPs might not be assigned."
        warn "Please install cloud-provider-kind or run it manually."
    fi
else
    log "cloud-provider-kind is running."
fi

# 2. Run Terraform
log "Applying Terraform..."
cd "$INFRA_DIR"
terraform init
terraform apply -auto-approve
cd - > /dev/null

# 3. Apply Ingress Initially
log "Applying initial Ingress to trigger IP allocation..."
kubectl apply -f "$INGRESS_FILE"

# 4. Wait for Ingress IP
log "Waiting for Ingress IP..."
MAX_RETRIES=30
SLEEP_SEC=5
INGRESS_IP=""

for i in $(seq 1 $MAX_RETRIES); do
    INGRESS_IP=$(kubectl get ingress typeorm-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    
    if [ -n "$INGRESS_IP" ]; then
        log "Found Ingress IP: $INGRESS_IP"
        break
    fi
    
    echo "Waiting for Ingress IP... ($i/$MAX_RETRIES)"
    sleep $SLEEP_SEC
done

if [ -z "$INGRESS_IP" ]; then
    error "Timed out waiting for Ingress IP."
fi

# 5. Update and Apply Ingress
log "Updating Ingress with IP: $INGRESS_IP"
HOST="${INGRESS_IP}.nip.io"

# Create a temporary ingress file with matched host
# We assume the structure matches the one in ingress.yaml
sed "s/host: .*/host: $HOST/g" "$INGRESS_FILE" | kubectl apply -f -

log "Ingress applied with host: $HOST"

# Wait for Ingress to be ready? Usually immediate with Nginx if controller is up.
# Give it a moment.
sleep 5

# 5. Run Tests
log "Running Tests against $HOST..."
URL="http://$HOST"

log ">>> Functional Tests <<<"
./"$TEST_DIR"/functional_tests.sh "$URL"

log ">>> Load Tests (k6) <<<"
k6 run -e BASE_URL="$URL" "$TEST_DIR"/load_test.js

log "Deployment and Testing Complete!"
echo ""
echo "---------------------------------------------------"
echo "App Endpoint: $URL/posts"
echo "---------------------------------------------------"
