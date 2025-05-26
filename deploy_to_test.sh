#!/bin/bash

# Deploy to Test - Development Workflow Automation
# Syncs changes from working repo to test repo, builds Docker image, and pushes to registry
# Author: Generated for Hisma's development workflow

set -e  # Exit on any error

# Configuration
WORKING_REPO="/home/hisma/docker/vscode/config/workspace/cline_projects/open-webui/"
TEST_REPO="/home/hisma/docker/vscode/config/workspace/open_webui"
IMAGE_NAME="openwebui:cuda12"
REGISTRY_TAG="hisma/openwebui:dev"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Start deployment
echo "========================================"
echo "🚀 Starting Deploy to Test Pipeline"
echo "========================================"
echo "Working Repo: $WORKING_REPO"
echo "Test Repo: $TEST_REPO"
echo "Image: $IMAGE_NAME → $REGISTRY_TAG"
echo ""

# Step 1: Sync changes
print_status "🔄 Step 1/4: Syncing changes from working repo to test repo..."
if rsync -av --exclude='.git' "$WORKING_REPO" "$TEST_REPO"; then
    print_success "Sync completed successfully"
else
    print_error "Sync failed"
    exit 1
fi
echo ""

# Step 2: Build Docker image
print_status "🐳 Step 2/4: Building Docker image with CUDA support..."
cd "$TEST_REPO" || {
    print_error "Failed to change to test repo directory: $TEST_REPO"
    exit 1
}

if docker build \
    --build-arg USE_CUDA=true \
    --build-arg USE_CUDA_VER=cu121 \
    --build-arg USE_OLLAMA=false \
    -t "$IMAGE_NAME" .; then
    print_success "Docker build completed successfully"
else
    print_error "Docker build failed"
    exit 1
fi
echo ""

# Step 3: Tag image
print_status "🏷️  Step 3/4: Tagging image for registry..."
if docker tag "$IMAGE_NAME" "$REGISTRY_TAG"; then
    print_success "Image tagged successfully: $REGISTRY_TAG"
else
    print_error "Image tagging failed"
    exit 1
fi
echo ""

# Step 4: Push to Docker Hub
print_status "📤 Step 4/4: Pushing image to Docker Hub..."
if docker push "$REGISTRY_TAG"; then
    print_success "Image pushed successfully to Docker Hub"
else
    print_error "Docker push failed"
    exit 1
fi
echo ""

# Final success message
echo "========================================"
echo "🎉 Deployment Pipeline Completed!"
echo "========================================"
echo "✅ Changes synced to test repo"
echo "✅ Docker image built: $IMAGE_NAME"
echo "✅ Image tagged: $REGISTRY_TAG"
echo "✅ Image pushed to Docker Hub"
echo ""
echo "Your development changes are now available in the test environment!"
echo "Image: $REGISTRY_TAG"
echo ""
