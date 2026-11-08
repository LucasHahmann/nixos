# Entwicklung & Nix-Tooling
{ pkgs, ... }:

{
  programs.vim.enable = true;

  programs.git = {
    enable = true;
    config = {
      user.name = "Lucas Hahmann";
      user.email = "lucas@hahmann-trier.de";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  environment.systemPackages = with pkgs; [
    vscodium
    claude-code
    python3
    gh # GitHub-CLI: `gh auth login` richtet die Zugangsdaten für git push ein

    # Laufzeit für Claude-Code-Plugins
    nodejs # npx: context7, chrome-devtools-mcp
    typescript
    typescript-language-server # typescript-lsp
    chromium # Browser für chrome-devtools-mcp

    # Nix: Language-Server + Formatter (für VSCodium)
    nixd
    nixfmt
  ];
}
