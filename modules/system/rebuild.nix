# `rebuild`: baut das System und committet + pusht die Config danach automatisch nach GitHub.
#
#   rebuild                       switch, Commit-Nachricht "Generation <n>"
#   rebuild "Bluetooth an"        switch mit eigener Commit-Nachricht
#   rebuild test                  nur testen – kein Commit, kein Push
#   rebuild boot "Kernel-Update"  erst beim nächsten Neustart aktiv, wird committet
#
# Committet wird nur, wenn der Build erfolgreich war.
{ pkgs, ... }:

let
  rebuild = pkgs.writeShellApplication {
    name = "rebuild";
    runtimeInputs = [ pkgs.git ];
    text = ''
      cd /etc/nixos

      action="switch"
      case "''${1:-}" in
        switch | boot | test) action="$1"; shift ;;
      esac
      message="''${1:-}"

      echo "==> nixos-rebuild $action"
      sudo nixos-rebuild "$action"

      if [ "$action" = "test" ]; then
        echo "==> Nur getestet – kein Commit."
        exit 0
      fi

      git add -A
      if git diff --cached --quiet; then
        echo "==> Keine Änderungen an der Config – nichts zu committen."
      else
        generation=$(readlink /nix/var/nix/profiles/system | grep -oE '[0-9]+')
        git status --short
        git commit --quiet -m "''${message:-Generation $generation}"
        echo "==> Committet: $(git log -1 --format=%s)"
      fi

      if git push --quiet; then
        echo "==> Nach GitHub gepusht."
      else
        echo "==> Push fehlgeschlagen – später mit 'git push' in /etc/nixos nachholen." >&2
      fi
    '';
  };
in
{
  environment.systemPackages = [ rebuild ];
}
