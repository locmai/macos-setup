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
}
