#!/bin/bash

# AlgoKit Repository Installation Script
# This script clones all AlgoKit repositories in the same directory structure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}AlgoKit Repository Installation Script${NC}"
echo -e "${YELLOW}This will clone all AlgoKit repositories into the current directory${NC}"
echo ""

# Ask user for URL preference
echo -e "${BLUE}Choose URL format for cloning:${NC}"
echo "1) HTTPS (recommended for most users)"
echo "2) SSH (requires SSH key setup)"
read -p "Enter your choice (1 or 2): " url_choice

case $url_choice in
    1)
        USE_SSH=false
        echo -e "${GREEN}Using HTTPS URLs${NC}"
        ;;
    2)
        USE_SSH=true
        echo -e "${GREEN}Using SSH URLs${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice. Defaulting to HTTPS${NC}"
        USE_SSH=false
        ;;
esac
echo ""

# Function to convert URL based on user preference
get_repo_url() {
    local base_url="$1"
    if [ "$USE_SSH" = true ]; then
        # Convert HTTPS to SSH format
        echo "git@github.com:algorandfoundation/${base_url}.git"
    else
        # Use HTTPS format
        echo "https://github.com/algorandfoundation/${base_url}.git"
    fi
}

# Function to clone repository if it doesn't exist
clone_repo() {
    local dir_path="$1"
    local repo_name="$2"
    local repo_url=$(get_repo_url "$repo_name")
    local display_name=$(basename "$dir_path")
    
    if [ -d "$dir_path" ]; then
        echo -e "${YELLOW}Directory $dir_path already exists, skipping...${NC}"
        return
    fi
    
    echo -e "${GREEN}Cloning $display_name...${NC}"
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dir_path")"
    
    git clone "$repo_url" "$dir_path"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Successfully cloned $display_name${NC}"
    else
        echo -e "${RED}✗ Failed to clone $display_name${NC}"
    fi
    echo ""
}

# Create directory structure and clone repositories
echo -e "${YELLOW}Creating directory structure and cloning repositories...${NC}"
echo ""

# Main algokit repo
clone_repo "algokit" "algokit"

# CLI
clone_repo "cli/algokit-cli" "algokit-cli"

# Client generators
clone_repo "client-generators/algokit-client-generator-py" "algokit-client-generator-py"
clone_repo "client-generators/algokit-client-generator-ts" "algokit-client-generator-ts"

# Core
clone_repo "core/algokit-core" "algokit-core"

# Dispenser
clone_repo "dispenser/algokit-dispenser-api" "algokit-dispenser-api"

# Lora
clone_repo "lora/algokit-explore" "algokit-explore"
clone_repo "lora/algokit-lora" "algokit-lora"

# Puya
clone_repo "puya/puya-ts" "puya-ts"
clone_repo "puya/puya" "puya"

# Subscriber
clone_repo "subscriber/algokit-subscriber-py" "algokit-subscriber-py"
clone_repo "subscriber/algokit-subscriber-ts" "algokit-subscriber-ts"

# Templates
clone_repo "templates/algokit-base-template" "algokit-base-template"
clone_repo "templates/algokit-beaker-default-template" "algokit-beaker-default-template"
clone_repo "templates/algokit-fullstack-template" "algokit-fullstack-template"
clone_repo "templates/algokit-python-template" "algokit-python-template"
clone_repo "templates/algokit-react-frontend-template" "algokit-react-frontend-template"
clone_repo "templates/algokit-templates" "algokit-templates"
clone_repo "templates/algokit-typescript-template" "algokit-typescript-template"

# Testing
clone_repo "testing/algokit-avm-vscode-debugger" "algokit-avm-vscode-debugger"
clone_repo "testing/algokit-utils-ts-debug" "algokit-utils-ts-debug"
clone_repo "testing/algorand-python-testing" "algorand-python-testing"
clone_repo "testing/algorand-typescript-testing" "algorand-typescript-testing"

# Utils
clone_repo "utils/algokit-utils-py" "algokit-utils-py"
clone_repo "utils/algokit-utils-ts" "algokit-utils-ts"

echo -e "${GREEN}All repositories have been processed!${NC}"
if [ "$USE_SSH" = true ]; then
    echo -e "${BLUE}Used SSH URLs - ensure your SSH keys are configured${NC}"
else
    echo -e "${BLUE}Used HTTPS URLs${NC}"
fi