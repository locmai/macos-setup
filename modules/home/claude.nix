{ config, pkgs, ... }:

{
  home.file = {
    # Claude Code configuration files
    ".claude/CLAUDE.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workspaces/agent-setup/CLAUDE.md";
    };

    ".claude/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workspaces/agent-setup/settings.json";
    };

    ".claude/.gitignore" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workspaces/agent-setup/.gitignore";
    };

    # Agent definitions
    ".claude/agents" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workspaces/agent-setup/agents";
      recursive = true;
    };

    # Custom skills
    ".claude/skills" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workspaces/agent-setup/skills";
      recursive = true;
    };

    # Custom hooks (if any)
    ".claude/hooks" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workspaces/agent-setup/hooks";
      recursive = true;
    };
  };
}
