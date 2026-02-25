{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    act
    aria2
    bitwarden-cli
    claude-code
    claude-monitor
    curl
    direnv
    docker
    fd
    fzf
    gh
    git
    gnupg
    imagemagick
    cairo
    librsvg
    jq
    mosh
    neovim
    nnn
    opentofu
    rbw
    ripgrep
    sslscan
    step-cli
    tree
    unzip
    watch
    wget
    zoxide
    terragrunt
    yq-go
    yamllint
    (pass.withExtensions (ext: with ext; [ pass-otp ]))
  ];

  environment.systemPath = [
    config.homebrew.brewPrefix
  ];

  environment.variables = {
    KUBE_EDITOR = "nvim";
    EDITOR = "nvim";
  };

  homebrew = {
    enable = true;
    taps = [ "FelixKratz/formulae" "chainguard-dev/tap" ];
    brews = [ "cookiecutter" "pinentry" "llvm" "libpq" "tfenv" "istioctl" ];
    casks = [ "kitty" "session-manager-plugin" "cursor" "signal" ];
  };

  system.primaryUser = "lmai";
  system.defaults = {
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

  nix = {
    enable = true;
    settings = {
      auto-optimise-store = false;
      experimental-features = [ "nix-command" "flakes" ];
      allowed-users = [ "@admin" ];
      trusted-users = [ "@admin" ];
    };
    optimise = {
      automatic = true;
    };
    linux-builder = {
      enable = true;
      config = {
        virtualisation = {
          cores = 8;
          darwin-builder = {
            diskSize = 128 * 1024;
            memorySize = 16 * 1024;
          };
        };
      };
    };
  };

  programs = {
    zsh = {
      enable = true;
      enableBashCompletion = false;
      enableCompletion = false;
      promptInit = "";
    };
    direnv = {
      enable = true;
      silent = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;
}
