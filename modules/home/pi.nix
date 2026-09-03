{ config, pkgs, ... }:

{
  home.file = {
    # Pi agent instructions, shared with Claude Code's CLAUDE.md
    ".pi/agent/AGENTS.md" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Workspaces/agent-setup/.claude/CLAUDE.md";
    };
  };
}
