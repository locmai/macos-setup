{ config, pkgs, ... }:

{
  home.file = {
    # OpenCode configuration file
    ".config/opencode/opencode.jsonc" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.config/opencode/opencode.jsonc";
    };

    # OpenCode agents instructions
    ".config/opencode/AGENTS.md" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.config/opencode/AGENTS.md";
    };

    # Agent definitions
    ".config/opencode/agents" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.config/opencode/agents";
      recursive = true;
    };

    # Custom skills
    ".config/opencode/skills" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.config/opencode/skills";
      recursive = true;
    };

    # Custom commands
    ".config/opencode/commands" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.config/opencode/commands";
      recursive = true;
    };
  };

  # Symlink opencode plugins from ~/.claude plugin cache into ~/.config/opencode/plugins/
  # Scans ~/.claude/plugins/cache/*/*/<version>/.opencode/plugins/* on every activation.
  home.activation.linkOpencodePlugins = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    plugin_dir="$HOME/.config/opencode/plugins"
    cache_dir="$HOME/.claude/plugins/cache"

    # Rebuild the plugins dir from scratch
    rm -rf "$plugin_dir"
    mkdir -p "$plugin_dir"

    if [ -d "$cache_dir" ]; then
      for plugin_file in "$cache_dir"/*/*/.opencode/plugins/*; do
        [ -e "$plugin_file" ] || continue
        ln -sf "$plugin_file" "$plugin_dir/$(basename "$plugin_file")"
      done
    fi
  '';
}
