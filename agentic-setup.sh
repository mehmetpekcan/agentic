#!/usr/bin/env bash

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}================================================${NC}"
echo -e "${CYAN}🚀  Starting Agentic Setup...                   ${NC}"
echo -e "${CYAN}================================================${NC}\n"

echo -e "${BLUE}📦 Step 1: Normalizing generated root files...${NC}"

if [ -f "GEMINI.md" ]; then
  mkdir -p ".gemini"
  mv -f "GEMINI.md" ".gemini/GEMINI.md"
  echo -e "   ${GREEN}→${NC} Moved: ${CYAN}GEMINI.md${NC} to ${YELLOW}.gemini/GEMINI.md${NC}"
fi

if [ -f "AGENTS.md" ]; then
  for agent_dir in ".codex" ".cursor" ".rovodev"; do
    mkdir -p "$agent_dir"
    cp -f "AGENTS.md" "$agent_dir/AGENTS.md"
    echo -e "   ${GREEN}→${NC} Copied: ${CYAN}AGENTS.md${NC} to ${YELLOW}$agent_dir/AGENTS.md${NC}"
  done
  rm -f "AGENTS.md"
  echo -e "   ${GREEN}→${NC} Removed root ${CYAN}AGENTS.md${NC} after copying."
fi

echo -e "   ${GREEN}✅ Generated root files are normalized.${NC}\n"

# 2. Verify generated files are present in the repo
echo -e "${BLUE}📦 Step 2: Checking committed generated files...${NC}"

required_paths=(
  ".codex"
  ".codex/AGENTS.md"
  ".cursor"
  ".cursor/AGENTS.md"
  ".gemini"
  ".gemini/GEMINI.md"
  ".rovodev"
  ".rovodev/AGENTS.md"
  ".cursorignore"
  ".geminiignore"
)

missing_paths=()
for path in "${required_paths[@]}"; do
  if [ ! -e "$path" ]; then
    missing_paths+=("$path")
  fi
done

if [ "${#missing_paths[@]}" -gt 0 ]; then
  echo -e "   ${YELLOW}Missing generated file(s):${NC}"
  for path in "${missing_paths[@]}"; do
    echo -e "   ${YELLOW}→${NC} $path"
  done
  echo -e "\n   Run ${CYAN}rulesync generate${NC} after updating .rulesync, then run this script again to normalize the generated outputs."
  exit 1
fi

echo -e "   ${GREEN}✅ Generated files are present.${NC}\n"

# 3. Copy generated files to global vendor folders
echo -e "${BLUE}🔗 Step 3: Copying to global directories...${NC}"

copy_recursive() {
  local source_path="$1"
  local target_path="$2"
  local source_name
  source_name="$(basename "$source_path")"

  if [ "$source_name" = ".DS_Store" ]; then
    return
  fi

  case "$source_path" in
    .codex/skills/.system|.codex/skills/.system/*)
      return
      ;;
  esac

  if [ -d "$source_path" ]; then
    mkdir -p "$target_path"
    for item in "$source_path"/* "$source_path"/.[!.]* "$source_path"/..?*; do
      [ -e "$item" ] || continue
      local item_name
      item_name="$(basename "$item")"
      copy_recursive "$item" "$target_path/$item_name"
    done
  else
    mkdir -p "$(dirname "$target_path")"
    
    # Skip if source and target are the exact same physical file to prevent infinite loop
    if [ "$source_path" -ef "$target_path" ]; then
      echo -e "   ${YELLOW}→${NC} Skipped identical file: ${CYAN}$source_path${NC}"
      return
    fi

    # If it's a symlink or an existing file, remove it first
    if [ -L "$target_path" ] || [ -f "$target_path" ]; then
      rm -f "$target_path"
    fi

    cp -f "$source_path" "$target_path"
    echo -e "   ${GREEN}→${NC} Copied: ${CYAN}$source_path${NC} to ${YELLOW}$target_path${NC}"
  fi
}

copy_vendor() {
  local repo_folder="$1"
  local global_folder="$2"

  if [ -d "$repo_folder" ]; then
    mkdir -p "$global_folder"
    # Copy contents of the repo vendor folder to the global vendor folder
    for item in "$repo_folder"/* "$repo_folder"/.[!.]* "$repo_folder"/..?*; do
      if [ -e "$item" ]; then
        local item_name
        item_name="$(basename "$item")"
        copy_recursive "$item" "$global_folder/$item_name"
      fi
    done
  fi
}

# Copy each target's generated vendor folder to its global counterpart
copy_vendor ".codex" "$HOME/.codex"
copy_vendor ".cursor" "$HOME/.cursor"
copy_vendor ".gemini" "$HOME/.gemini"
copy_vendor ".rovodev" "$HOME/.rovodev"

# Copy the .rulesync folder itself to global
copy_vendor ".rulesync" "$HOME/.rulesync"

copy_file() {
  local repo_file="$1"
  local global_file="$2"

  if [ -f "$repo_file" ]; then
    mkdir -p "$(dirname "$global_file")"
    
    # Skip if source and target are the exact same physical file to prevent infinite loop
    if [ "$repo_file" -ef "$global_file" ]; then
      echo -e "   ${YELLOW}→${NC} Skipped identical file: ${CYAN}$repo_file${NC}"
      return
    fi

    # If it's a symlink, remove it first to avoid modifying the original source
    if [ -L "$global_file" ]; then
      rm -f "$global_file"
    fi

    # Only append if it's an ignore file and it already exists
    if [[ "$global_file" == *ignore ]] && [ -f "$global_file" ]; then
      echo "" >> "$global_file"
      cat "$repo_file" >> "$global_file"
      echo -e "   ${GREEN}→${NC} Appended: ${CYAN}$repo_file${NC} to ${YELLOW}$global_file${NC}"
    else
      if [ -f "$global_file" ]; then
        rm -f "$global_file"
      fi
      cp -f "$repo_file" "$global_file"
      echo -e "   ${GREEN}→${NC} Copied: ${CYAN}$repo_file${NC} to ${YELLOW}$global_file${NC}"
    fi
  fi
}

# Copy each target's generated ignore file to its global counterpart
copy_file ".codexignore" "$HOME/.codexignore"
copy_file ".cursorignore" "$HOME/.cursorignore"
copy_file ".geminiignore" "$HOME/.geminiignore"
copy_file ".rovodevignore" "$HOME/.rovodevignore"

echo -e "\n${CYAN}================================================${NC}"
echo -e "${GREEN}✨ Setup complete! You are ready to go.       ${NC}"
echo -e "${CYAN}================================================${NC}"
