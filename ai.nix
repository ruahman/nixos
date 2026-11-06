{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  NVIM_MCP_PKG = inputs.nvim-mcp.packages.${pkgs.system}.default;
in
{
  programs = {
    # Centralized MCP configurations
    mcp = {
      enable = true;
      servers = {

        context7 = {
          # Reference the natively packaged binary
          command = "${pkgs.context7-mcp}/bin/context7-mcp";
          args = [
            "--api-key"
            "$CONTEXT7_API_KEY" # Pulls safely from your shell environment variables
          ];
        };

        neovim = {
          # Resolves directly to the stable /nix/store execution binary path
          command = lib.getExe NVIM_MCP_PKG;
          args = [
            "--connect"
            "auto"
          ];
          env = {
            # Path to your active Neovim session socket
            NVIM_SOCKET_PATH = "/tmp/nvim";
            ALLOW_SHELL_COMMANDS = "true";
          };
        };

        playwright = {
          # Use the native binary from nixpkgs instead of npx
          command = "${pkgs.playwright-mcp}/bin/playwright-mcp";
          args = [
            "--headless"
          ];
          env = {
            # Explicitly tell Playwright where to look for the system-patched browser binaries
            PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
            PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
          };
        };

      };
    };

    claude-code = {
      enable = true;
      package = pkgs.claude-code;
      enableMcpIntegration = true;
      skills = {
        herdr = builtins.readFile ./skills/herdr/skill.md;
      };
    };

    pi-coding-agent = {
      enable = true;
      settings.packages = [
        "npm:pi-permission-system"
        "npm:pi-web-access"
        "npm:pi-plan-mode"
        "npm:pi-subagents"
        "npm:pi-mcp-extension"
      ];
    };
  };
}
