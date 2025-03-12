{
  description = "Zenful Darwin system flake";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.neovim
          pkgs.mkalias
          pkgs.python3
          pkgs.bat
          pkgs.php83Packages.composer
          pkgs.deno
          pkgs.docker
          pkgs.emscripten
          pkgs.eza
          pkgs.ffmpeg_7
          pkgs.fzf
          pkgs.gh
          pkgs.htop
          pkgs.httpie
          pkgs.jq
          pkgs.lazygit
          pkgs.luajit_openresty
          pkgs.luajitPackages.luarocks
          pkgs.neo4j
          pkgs.nodejs_22
          pkgs.jdk17
          pkgs.pandoc
          pkgs.pipx
          pkgs.plantuml-c4
          pkgs.postgresql
          pkgs.ripgrep
          pkgs.rustup
          pkgs.starship
          pkgs.tmux
          pkgs.tmuxinator
          pkgs.trash-cli
          pkgs.tree
          pkgs.wget
          pkgs.yarn
          pkgs.yt-dlp
          pkgs.zoxide
          pkgs.zsh
          pkgs.alacritty
          pkgs.camunda-modeler
          pkgs.discord
          pkgs.drawio
          pkgs.fira-code
          pkgs.gitkraken
          pkgs.google-chrome
          pkgs.iina
          pkgs.obsidian
          pkgs.shortcat
          pkgs.stats
          pkgs.vscode
          pkgs.openconnect_openssl
          pkgs.colima
          pkgs.cocoapods
          pkgs.flutter
          # pkgs.lunarvim
          pkgs.tldr
          pkgs.ollama
          pkgs.wezterm
        ];

      homebrew = {
        enable = true;
        taps = [
          "nikitabobko/tap"
        ];
        brews = [
          "mas"
          "displayplacer"
        ];
        casks = [
	  "logi-options+"
	  "arc"
	  "intellij-idea"
          "raycast"
          "todoist"
          "aerospace"
          "blitz-gg"
          "cleanshot"
          "dozer"
          "elgato-control-center"
          "epic-games"
          "font-hack-nerd-font"
          "font-jetbrains-mono-nerd-font"
          "font-sf-pro"
          "github"
          "macsvg"
          "microsoft-auto-update"
          "modern-csv"
          "nordvpn"
          "signal"
          "sourcetree"
          "whatsapp"
          "1password"
          "clipgrab"
          "firefox"
          "insomnia"
          "steam"
          "xmind"
          "spotify"
          "microsoft-teams"
        ];
        masApps = {
          "Dropover" = 1355679052;
          "GarageBand" = 682658836;
          "iMovie" = 408981434;
          "Keynote" = 409183694;
          "Microsoft Excel" = 462058435;
          "Microsoft OneNote" = 784801555;
          "Microsoft Outlook" = 985367838;
          "Microsoft PowerPoint" = 462062816;
          "Microsoft To Do" = 1274495053;
          "Microsoft Word" = 462054704;
          "Numbers" = 409203825;
          "OneDrive" = 823766827;
          "Pages" = 409201541;
          "Prime Video" = 545519333;
          "Xcode" = 497799835;
          "Microsoft App" = 1295203466;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';

      system.defaults = {
        # Dock Settings
        dock.autohide = true;
        dock.orientation = "left";
        dock.tilesize = 26;
        dock.autohide-delay = 0.0;
        dock.show-recents = false;
        dock.mineffect = "scale";
        dock.mru-spaces = false;

        # Finder Settings
        finder.AppleShowAllFiles = true;
        finder.ShowPathbar = true;
        finder.FXPreferredViewStyle = "clmv";
        finder._FXShowPosixPathInTitle = true;
        finder._FXSortFoldersFirst = true;
        finder.AppleShowAllExtensions = true;
        finder.QuitMenuItem = true;

        # Trackpad Settings
        trackpad.Clicking = true;
        trackpad.TrackpadThreeFingerDrag = true;
        trackpad.Dragging = false;

        # NSGlobalDomain Settings
        NSGlobalDomain.AppleSpacesSwitchOnActivate = false;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      # Optimise storage on every build
      nix.optimise.automatic = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew 
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;
            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "edwinscharfe";
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."air".pkgs;
  };
}
