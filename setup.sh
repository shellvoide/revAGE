#!/usr/bin/env bash
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
BOLD='\033[1m'
info()    { echo -e "${CYAN}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR]${NC}  $*"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BOLD}${CYAN}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║       RE Agent SDK — Installation Script            ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

info "Checking Node.js..."
if ! command -v node &>/dev/null; then
  error "Node.js not found. Install it: https://nodejs.org (v18+ required)"
  exit 1
fi
NODE_VER=$(node -e "console.log(process.version.slice(1).split('.')[0])")
if [ "$NODE_VER" -lt 18 ]; then
  error "Node.js v18+ required (found v$NODE_VER)"
  exit 1
fi
success "Node.js $(node --version)"

info "Installing Pi Coding Agent..."
if command -v pi &>/dev/null; then
  success "Pi already installed"
else
  npm install -g @earendil-works/pi-coding-agent
  success "Pi installed"
fi

PI_DIR="$HOME/.pi/agent"
mkdir -p "$PI_DIR/extensions" "$PI_DIR/skills"

cp "$SCRIPT_DIR/extension/re-agent.ts"  "$PI_DIR/extensions/re-agent.ts"
cp "$SCRIPT_DIR/extension/providers.ts" "$PI_DIR/extensions/providers.ts"
success "Extensions installed"

cp -r "$SCRIPT_DIR/skill/re-toolkit" "$PI_DIR/skills/"
success "Skill installed"

cp "$SCRIPT_DIR/AGENTS.md" "$PI_DIR/AGENTS.md"
success "AGENTS.md installed"

mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/re" << 'LAUNCHER_EOF'
#!/usr/bin/env bash
export GHIDRA_HOME="${GHIDRA_HOME:-/snap/ghidra/35/ghidra_12.0_PUBLIC}"

BANNER="\033[36m
  ██████╗ ███████╗      █████╗  ██████╗ ███████╗
  ██╔══██╗██╔════╝     ██╔══██╗██╔════╝ ██╔════╝
  ██████╔╝█████╗       ███████║██║  ███╗█████╗
  ██╔══██╗██╔══╝       ██╔══██║██║   ██║██╔══╝
  ██║  ██║███████╗     ██║  ██║╚██████╔╝███████╗
  ╚═╝  ╚═╝╚══════╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
\033[0m"
echo -e "$BANNER"

if [ -n "$1" ] && [ -f "$1" ]; then
  export RE_INITIAL_TARGET="$1"
  echo -e "\033[33m  Target: $1\033[0m"; echo ""
fi

if [ -n "$GROQ_API_KEY" ]; then
  DEFAULT_MODEL="--model groq/llama-3.3-70b-versatile"
elif [ -n "$ANTHROPIC_API_KEY" ]; then
  DEFAULT_MODEL="--model anthropic/claude-sonnet-4-5"
else
  DEFAULT_MODEL="--model opencode-zen/deepseek-v4-flash-free"
  echo -e "\033[32m  Using OpenCode Zen (free model — no API key needed)\033[0m"; echo ""
fi

exec pi $DEFAULT_MODEL "$@"
LAUNCHER_EOF

chmod +x "$HOME/.local/bin/re"
success "Launcher created: ~/.local/bin/re"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  warn "Add to ~/.bashrc:  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

if [ -z "$GHIDRA_HOME" ] && [ ! -f "/snap/ghidra/35/ghidra_12.0_PUBLIC/support/analyzeHeadless" ]; then
  warn "Ghidra not detected. For Ghidra decompilation:"
  warn "  snap install ghidra"
  warn "  export GHIDRA_HOME=/snap/ghidra/35/ghidra_12.0_PUBLIC"
fi

echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║           Setup Complete! ✅                        ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo "  Run:         ${BOLD}re${NC}"
echo "  Analyze:     ${BOLD}re ./binary${NC}"
echo "  Switch LLM:  ${BOLD}Ctrl+L${NC}"
echo "  Analyze cmd: ${BOLD}/re:analyze <file>${NC}"
echo "  Decompile:   ${BOLD}/re:decompile <file> [func]${NC}"
echo "  Workflows:   ${BOLD}/skill:re-toolkit${NC}"
echo ""
