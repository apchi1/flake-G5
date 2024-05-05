{ config, pkgs, lib, callPackage, ... }: {
#security.polkit.enable = true;
imports = [ 
# Include the results of the hardware scan.
	./hardware-configuration.nix		
];

boot = {
	kernelModules = ["nvidia"];
	extraModulePackages = [];
	kernelPackages = pkgs.pkgs.linuxPackages_xanmod_latest;
	loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
#		systemd-boot.consoleMode = "max";
		systemd-boot.configurationLimit = 10;
	};
};

# Networking
networking = {
	hostName = "Gidrex";
	proxy.default = "http://localhost:1092";
	proxy.noProxy = "127.0.0.1,localhost";
	networkmanager.enable = true;
};

# Locale
time.timeZone = "Europe/Moscow";
i18n.defaultLocale = "en_GB.UTF-8";

# Audio
hardware.pulseaudio.enable = true;

# User
users.users.gidrex = {
	shell = pkgs.zsh;
    isNormalUser = true;
    description = "Alexander";
    extraGroups = [ "networkmanager" "wheel" "audio" "input" "docker" "vboxusers" "input"];
    packages = with pkgs; [];
};

# Graphic
hardware = {
	opengl = {
		enable = true;
		driSupport32Bit = true;
		extraPackages = [];
	};
	nvidia = {
		open = false;
		nvidiaSettings = true;
		powerManagement.enable = true;
		dynamicBoost.enable = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
		prime = {
			offload.enable = true;
			offload.enableOffloadCmd = true;
			intelBusId =  "PCI:00:02:0";
    		nvidiaBusId = "PCI:01:00:0";
		};
#	modesetting.enable = true; # error
	};
};

# Docker
virtualisation.docker.enable = true;
virtualisation.docker.rootless = {
   enable = true;
   setSocketVariable = true;
};
virtualisation.containers.enable = true;
users.extraGroups.docker.members = [ "username-with-access-to-socket" ];


environment.variables.TERM = "kitty";

programs = {
	thunar.enable = true;
	zsh = {
    	enable = true;
    	autosuggestions.enable = true;
    	zsh-autoenv.enable = true;
    	syntaxHighlighting.enable = true;
    	ohMyZsh = {
      		enable = true;
      		theme = "robbyrussell";
      		plugins = [
        		"git"
        		"npm"
        		"history"
        		"node"
        		"rust"
        		"deno"
      	  ];
      };
  };
};
hardware.bluetooth.enable = true;

services.picom = {
  enable = true;
  inactiveOpacity = 0.98;
  activeOpacity = 1;
 /* opacityRules = [
    "50:class_g = 'firefox'"
    "20:class_g = 'kitty'"
    "90:class_g = 'rofi'"
  ];*/
  fade = true;
  vSync = true;
  shadow = true;
  fadeDelta = 4;
  fadeSteps = [0.02 0.5];
  backend = "glx";
};

# Allias
environment.shellAliases = {
	rebuild = "sudo nixos-rebuild switch --upgrade-all && cd ~/flake-G5 && ./auto-copy.sh && cd -";
};

# Services
services = {
	printing.enable = true;
	blueman.enable = true;
	xserver.layout = "us,ru";
	onlyoffice = {
		enable = true;
		hostname = "localhost";
	};
};

# Fonts
fonts.fontconfig.enable = true;
fonts.packages = with pkgs; [
	nerdfonts
	times-newer-roman
	noto-fonts
	jetbrains-mono
	monaspace
];

# Spotify open port
#networking.firewall.allowedTCPPorts = [ 57621 ];

nix.settings.experimental-features = ["nix-command" "flakes"];
nix.gc.automatic = true; #Garbage collector

# Packets
nixpkgs.config.allowUnfree = true;
environment.systemPackages = with pkgs;[
	git micro vim neofetch pciutils xsel 
	zip unzip gnutls
	
	kitty alacritty starship htop
	
	gradle openjdk #libcanberra 

	python3
	nodejs yarn
	cargo gcc cmake gnumake

	flameshot pick-colour-picker parcellite

	vscodium
	spotify spotifywm
	telegram-desktop
	onlyoffice-bin
	logseq

	appimage-run flatpak
	wine
	distrobox
	podman

	libinput xorg.xf86videofbdev xorg.xkbcomp
	libexecinfo i3 i3lock-fancy lightdm
	lxappearance nitrogen rofi pavucontrol
	tokyo-night-gtk catppuccin bibata-cursors
	
	blueman light
	vulkan-validation-layers
	cloudflared

	prismlauncher
];
/*
# Awesome 
services.xserver = {
    enable = true;
    displayManager = {
        sddm.enable = true;
        defaultSession = "none+awesome";
    };
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules

        luadbi-mysql # Database abstraction layer
      ];
    };
  };
*/
# i3
environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 
services.xserver = {
	libinput.enable = true;
	enable = true;
	videoDrivers = [ "nvidia" ];
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
    	enable = true;
    	extraPackages = with pkgs; [
        	i3status
        	i3lock
			i3blocks
    	];
    };
};

system.stateVersion = "23.11";
}
