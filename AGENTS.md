# AI Agents in exeuntu

This document describes the AI agents and assistants available in the exeuntu environment.

## Available Agents

### 1. Shelley
Shelley is the primary AI assistant integrated into exe.dev VMs.

**Features:**
- Real-time coding assistance
- Terminal integration
- Project context awareness
- Collaborative development

**Access:**
- Command: `shelley`
- Service: `systemctl status shelley`
- Port: 9999 (socket activation)

### 2. Claude CLI
Anthropic's Claude code assistant for the command line.

**Features:**
- Code generation and analysis
- Documentation generation
- Debugging assistance
- Natural language to code translation

**Access:**
- Command: `claude`
- Configuration: `~/.claude/`

**Usage Examples:**
```bash
# Ask Claude a question
claude "How do I implement a binary search in Python?"

# Generate code
claude "Create a REST API with Flask"

# Code review
claude "Review this code: $(cat myfile.py)"
```

### 3. Codex
OpenAI's Codex CLI tool for code generation and assistance.

**Features:**
- Multi-language code generation
- Code explanation
- Bug fixing suggestions
- Test generation

**Access:**
- Command: `codex`
- Configuration: `~/.codex/`

**Usage Examples:**
```bash
# Generate code
codex generate "quicksort algorithm in Go"

# Explain code
codex explain myfile.js

# Fix bugs
codex fix buggy_code.py
```

## Integration

All agents are pre-configured in the exeuntu environment with:
- Shared documentation (this file)
- Common configuration directories
- Environment-specific optimizations

## Best Practices

1. **Use the right tool for the job:**
   - Shelley: Interactive development, real-time assistance
   - Claude: Complex reasoning, documentation
   - Codex: Quick code generation, multiple languages

2. **Provide context:**
   - Include relevant file paths
   - Describe the problem clearly
   - Share error messages

3. **Iterate:**
   - Review generated code
   - Test thoroughly
   - Refine prompts based on results

## Configuration

Each agent can be configured through its respective directory:
- Shelley: `~/.config/shelley/`
- Claude: `~/.claude/`
- Codex: `~/.codex/`

## Support

For issues or questions:
- exe.dev documentation: https://exe.dev/docs
- GitHub: https://github.com/boldsoftware/exeuntu
