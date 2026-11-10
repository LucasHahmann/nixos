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

      # Direkt nach dem Switch lädt D-Bus neu – der Schlüsselbund (KWallet), aus dem
      # gh das GitHub-Token holt, antwortet dann kurz nicht. Daher: nie nach Passwort
      # fragen, sondern ein paar Sekunden warten und erneut versuchen.
      export GIT_TERMINAL_PROMPT=0
      for attempt in 1 2 3 4 5; do
        if git push --quiet 2>/dev/null; then
          echo "==> Nach GitHub gepusht."
          exit 0
        fi
        echo "==> Push-Versuch $attempt fehlgeschlagen, neuer Versuch in 3 s …"
        sleep 3
      done
      echo "==> Push fehlgeschlagen – später mit 'git push' in /etc/nixos nachholen." >&2
      git push --quiet || true # letzter Versuch mit Fehlermeldung
    '';
  };
in
{
  environment.systemPackages = [ rebuild ];
}
