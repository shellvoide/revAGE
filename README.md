RE Agent SDK
A reverse engineering AI agent with 20 specialized tools, built on Pi Coding Agent.
Quick Install
chmod +x setup.sh && ./setup.sh

Then:
re                           # Launch interactive RE Agent
re ./target_binary           # Launch with a binary

No API key needed — uses free OpenCode Zen models by default.
20 RE Tools
Tool	Description
re_file_info	Binary format, arch, hashes
re_strings	Extract & filter strings
re_objdump	Disassemble with objdump
re_readelf	Parse ELF structure
re_hexdump	Hex dump at any offset
re_binwalk	Firmware scanning/extraction
re_r2_cmd	Full radare2 commands
re_ghidra	Ghidra headless decompile
re_yara_scan	YARA pattern matching
re_entropy	Packer/crypto detection
re_strace	Syscall tracing
re_ltrace	Library call tracing
re_nm_symbols	Symbol table
re_checksec	Security mitigations
re_patch_binary	Byte patching with backup
re_diff	Binary comparison
re_extract_section	Extract ELF sections
re_disasm_capstone	Shellcode disassembly
re_find_crypto	Crypto constant detection
re_deobfuscate	XOR/base64/zlib decode

Slash Commands
·	/re:analyze <file> — full recon pipeline
·	/re:decompile <file> [func] — Ghidra decompile
·	/re:strings <file> [filter] — string extraction
·	/re:yara <file> — YARA scan
·	/re:diff <a> <b> — binary diff
·	/re:shellcode <hex> — shellcode analysis
·	/skill:re-toolkit — RE workflow guide
Model Switching
Press Ctrl+L to switch providers at runtime.
Provider	Model	Cost
OpenCode Zen	DeepSeek V4 Flash Free	Free
Groq	Llama 3.3 70B	Free tier
Ollama	Any local model	Free
Anthropic	Claude Sonnet 4	API key required

Requirements
·	Node.js 18+
·	Linux (tested on Ubuntu/Debian)
·	Ghidra (optional, for decompilation)
·	Core tools: file, strings, objdump, readelf, nm, xxd
Project Structure
re-agent-sdk/
├── setup.sh                    # Installer
├── README.md                   # This file
├── AGENTS.md                   # RE identity prompt
├── extension/
│   ├── re-agent.ts             # 20 tools + 6 commands
│   └── providers.ts            # Model providers
└── skill/
    └── re-toolkit/
        └── SKILL.md            # RE workflows

