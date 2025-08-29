# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Allow Unfree software
  nixpkgs.config.allowUnfree = true;
  # Allow CUDA
  nixpkgs.config.cudaSupport = true;

  # Use the systemd boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.kernelParams = [
    "nomodeset"
    "video=uvesafb:mode_options=1024x768-16@60,mtrr=0,scroll=ywrap,noedid"
  ];
  boot.zfs.extraPools = [
    "zpool"
    "backup"
  ];

  # Disable all sleep
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostId = "d0337a37";
  networking.hostName = "hamachi"; # Define your hostname.

  networking.nat = {
    enable = true;
    # Use "ve-*" when using nftables instead of iptables
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp7s0";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };
  networking.nftables.enable = false;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];

  # networking = {
  #   bridges.br0.interfaces = [ "enp7s0" ]; # Adjust interface accordingly
  #
  #   # Get bridge-ip with DHCP
  #   useDHCP = false;
  #   interfaces."br0".useDHCP = true;
  #
  #   # Set bridge-ip static
  #   interfaces."br0".ipv4.addresses = [{
  #     address = "192.168.100.3";
  #     prefixLength = 24;
  #   }];
  #   defaultGateway = "192.168.100.1";
  #   nameservers = [ "192.168.100.1" ];
  # };
  #

  # Set your time zone.
  time.timeZone = "US/Pacific";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sashimi = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWtHg2vvIXWFOvy6UoicvBQM9jItyOCOhoCZy1rkj1Y sashimi@Sakana"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDvFbjVJZIjyUEGkkCgYl6HCCtgjzUcV+gNF5+db2vK sashimi@Kujira"
    ];
    linger = true;
  };

  users.users.jliu = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIS2bO2QPK0yFPr+K/LVS3KkXR44sItK62CMkLABTJWY jliu@iMac"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4fo0KYrlFSErX1uJufdTGrRLGc+lqHhMhyHjb+hJ6m jliu@Mac"
    ];
  };

  users.users.cliu = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILW8YcRKUOBaZXbpdvvw2USe+WtNaEXNDktbt4U5ycjb cliu@MacBookPro"
    ];
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  environment.systemPackages = with pkgs; [
    # Editors
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    nano

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    tmux # Terminal multiplexer
    hyperfine # Benchmarking tool

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # dig + nslookup
    ldns # replacement of dig, it provide the command drill
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses
    speedtest-cli # speedtest.net CLI tool

    # system monitoring tools
    btop
    iotop # io monitoring
    iftop # network monitoring
    sysstat
    lm_sensors # for sensors command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # Misc
    git
    wget
    tldr
    tree
    pfetch-rs # pretty system information tool

    # C/C++
    gcc
    gnumake
    cmake

    # Python
    python3

    # useful for docker/podman
    dive
    podman-tui
    docker-compose

  ];

  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      extraPackages = [ pkgs.zfs ];

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # List services that you want to enable:

  # Enable OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  # Open iperf3 firewall port
  # services.iperf3.openFirewall = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    5201
  ];
  networking.firewall.allowedUDPPorts = [
    5201
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.

  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
