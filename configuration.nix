{ pkgs, ... }:

{
  networking.hostName = "nixos-lab";
  time.timeZone = "Australia/Brisbane";

  # This VM is only for local experimentation. Never reuse its
  # plaintext demo password on a network-accessible machine.
  users.users.student = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    python3
    curl
    htop
  ];

  # A tiny service to verify that our declarative configuration works.
  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      default = true;
      locations."/".return = "200 'Hello from NixOS VM!'";
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 ];

  # Resources allocated only when building/running this as a QEMU VM.
  virtualisation.vmVariant.virtualisation = {
    memorySize = 2048;
    cores = 2;
  };

  # Keep this value at the release used when the system was created.
  system.stateVersion = "26.05";
}
