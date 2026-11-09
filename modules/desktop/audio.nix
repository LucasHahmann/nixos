# Sound über PipeWire
{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; # für JACK-Anwendungen

    # Mackie ProFX: Das Pult meldet 4 Wiedergabekanäle (USB 1-2 + USB 3-4), PipeWire macht
    # daraus "Surround 4.0". Spiele geben dann Raumklang auf die hinteren Kanäle = USB 3-4 aus,
    # die das Pult in den Main-Mix legt – und der geht per USB zurück an den PC (Discord-Mikro).
    # Lösung: USB 3-4 als AUX markieren. Stereo/Surround landet so nur auf USB 1-2,
    # Spiele-Surround wird automatisch auf Stereo heruntergemischt.
    wireplumber.extraConfig."51-profx-stereo" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "alsa_output.usb-LOUD_Technologies_Inc._ProFx-00.analog-surround-40"; }
          ];
          actions.update-props = {
            "audio.position" = [
              "FL"
              "FR"
              "AUX0"
              "AUX1"
            ];
            "node.description" = "ProFX (USB 1-2)";
          };
        }
      ];
    };
  };
}
