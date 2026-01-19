#!/bin/bash
# Custom MOTD snippet for exeuntu
# This is appended to .bashrc to show on each login

# Only show on interactive shells
if [[ $- == *i* ]]; then
    # Color codes
    CYAN='\033[0;36m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║        Welcome to exeuntu - exe.dev base image          ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${GREEN}AI Assistants:${NC}"
    echo "  • shelley - Primary AI assistant (port 9999)"
    echo "  • claude  - Anthropic's Claude CLI"
    echo "  • codex   - OpenAI's Codex CLI"
    echo ""
    
    echo -e "${GREEN}Development Tools:${NC}"
    echo "  • Docker, Docker Compose"
    echo "  • Python (with uv, pip, pipx)"
    echo "  • Go, Node.js"
    echo "  • git, gh (GitHub CLI)"
    echo ""
    
    echo -e "${YELLOW}Quick Start:${NC}"
    echo "  • Run 'shelley' to start the AI assistant"
    echo "  • Check 'cat ~/.config/shelley/AGENTS.md' for AI agent docs"
    echo "  • Use 'docker ps' to see running containers"
    echo ""
fi
