{ config, pkgs, ... }:

{
  home.file = {
    # Claude Code configuration files
    ".claude/CLAUDE.md" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.claude/CLAUDE.md";
    };

    ".claude/settings.json" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.claude/settings.json";
    };

    ".claude/settings.local.json" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.claude/settings.local.json";
    };

    # MCP configuration
    ".mcp.json" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.mcp.json";
    };

    # Agent definitions
    ".claude/agents" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.claude/agents";
      recursive = true;
    };

    # Custom skills
    ".claude/skills" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.claude/skills";
      recursive = true;
    };

    # Custom hooks (if any)
    ".claude/hooks" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.claude/hooks";
      recursive = true;
    };
  };
}
