# My Dotfiles & Personal Tooling

Welcome to my personal dotfiles and tooling repository! This repo contains my configurations, scripts, and rules for various development tools and AI coding assistants I use daily.

## Setup

This repository includes generated AI agent tooling from `rulesync` and a setup script that copies those committed outputs into the global tool directories.

### `agentic-setup.sh`

I use `rulesync` to centralize rules, commands, and subagents across all my AI coding assistants (Cursor, RovoDev, Codex CLI, Gemini CLI) based on the `rulesync.jsonc` configuration.

The generated tool-specific configurations are tracked in this repo. After changing `.rulesync`, run `rulesync generate`, then run `agentic-setup.sh` to move the generated root files into their tool directories and copy everything to the global vendor folders (e.g., `~/.cursor`, `~/.codex`). Commit the normalized generated outputs.

**Run the setup:**

```bash
./agentic-setup.sh
```
