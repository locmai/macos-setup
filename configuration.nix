{ config, pkgs , ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl

  environment.systemPackages = with pkgs; [
    act
    aria
    cargo
    colima
    curl
    direnv
    docker
    fd
    fzf
    gh
    git
    gnupg
    go
    jq
    k9s
    kubectl
    kubectl-tree
    kubectx
    kubernetes-helm
    kustomize
    mosh
    neovim
    nnn
    nodePackages.npm
    nodePackages.yarn
    nodejs
    opentofu
    pinentry_mac
    rbw
    ripgrep
    rust-analyzer
    tree
    unzip
    watch
    wget
    zoxide
    terragrunt
    tflint
    yabai
    yq-go

    (pass.withExtensions (ext: with ext; [
      pass-otp
    ]))
  ];

  environment.systemPath = [
    config.homebrew.brewPrefix # TODO https://github.com/LnL7/nix-darwin/issues/596
  ];

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
    ];
  };

  # Homebrew packages
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      { name = "homebrew/cask"; }
    ];
    brews = [
      "azure-cli"
      "libpq"
      "sqlcmd"
    ];
    casks = [
      "kitty"
    ];
  };

  system.defaults = {
    alf = {
      globalstate = 1;
    };
    dock = {
      autohide = true;
      minimize-to-application = true;
      mru-spaces = false;
      showhidden = true;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
    CustomUserPreferences = {
      "com.apple.Safari" = {
        AlwaysRestoreSessionAtLaunch = true;
        AutoOpenSafeDownloads = false;
        EnableNarrowTabs = false;
        IncludeDevelopMenu = true;
        NeverUseBackgroundColorInToolbar = true;
        ShowFullURLInSmartSearchField = true;
        ShowOverlayStatusBar = true;
        ShowStandaloneTabBar = false;
      };
    };
  };

  services.nix-daemon.enable = true;

  nix = {
    # configureBuildUsers = true;
    settings = {
      auto-optimise-store = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [
        "@admin"
      ];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    enableBashCompletion = false;
    enableCompletion = false;
    promptInit = "";
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nixpkgs.config.allowUnfree = true;
}

