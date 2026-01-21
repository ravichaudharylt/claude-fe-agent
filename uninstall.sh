#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# Claude FE Agent - Uninstall Script
# ═══════════════════════════════════════════════════════════════════════════════
# This script removes symlinks created by setup.sh and optionally restores backups
# ═══════════════════════════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CLAUDE_DIR="$HOME/.claude"

echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}           Claude FE Agent - Uninstall Script                       ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

remove_symlink() {
    local target="$1"
    local name="$2"

    if [ -L "$target" ]; then
        rm "$target"
        echo -e "  ${GREEN}✓${NC} Removed $name symlink"

        # Check for backup
        latest_backup=$(ls -t "${target}.backup."* 2>/dev/null | head -1)
        if [ -n "$latest_backup" ]; then
            read -p "    Restore backup $(basename $latest_backup)? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mv "$latest_backup" "$target"
                echo -e "    ${GREEN}✓${NC} Restored from backup"
            fi
        fi
    elif [ -e "$target" ]; then
        echo -e "  ${YELLOW}⊘${NC} $name is not a symlink, skipping"
    else
        echo -e "  ${YELLOW}⊘${NC} $name doesn't exist"
    fi
}

echo -e "${YELLOW}Removing symlinks...${NC}"
echo ""

remove_symlink "$CLAUDE_DIR/CLAUDE.md" "CLAUDE.md"
remove_symlink "$CLAUDE_DIR/settings.json" "settings.json"
remove_symlink "$CLAUDE_DIR/workflow-config.json" "workflow-config.json"
remove_symlink "$CLAUDE_DIR/skills" "skills/"
remove_symlink "$CLAUDE_DIR/agents" "agents/"
remove_symlink "$CLAUDE_DIR/memory" "memory/"

echo ""
echo -e "${GREEN}Uninstall complete.${NC}"
echo ""
echo "Your ~/.claude/ directory now uses local files (or restored backups)."
echo "The agent repository remains untouched - you can reinstall anytime with:"
echo "  ./setup.sh"
