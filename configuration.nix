{ config, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl
  environment.systemPackages = with pkgs; [
    act
    aria
    curl
    direnv
    docker
    fd
    fzf
    gh
    git
    gnupg
    go
    imagemagick
    cairo
    librsvg
    istioctl
    jq
    mosh
    neovim
    nnn
    opentofu
    rbw
    ripgrep
    sslscan
    step-cli
    tflint
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
    config.homebrew.brewPrefix # TODO https://github.com/LnL7/nix-darwin/issues/596
  ];

  environment.variables = {
    KUBE_EDITOR = "nvim";
    EDITOR = "nvim";
  };

  # Homebrew packages
  homebrew = {
    enable = true;
    taps = [ "FelixKratz/formulae" ];
    brews = [ "cookiecutter" "pinentry" "llvm" "libpq" "tfenv" ];
    casks = [ "kitty" "session-manager-plugin" ];
  };

  system.primaryUser = "lmai";
  system.defaults = {
    alf = { globalstate = 1; };
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
    # configureBuildUsers = true;
    settings = {
      auto-optimise-store = false;
      experimental-features = [ "nix-command" "flakes" ];
      allowed-users = [ "@admin" ];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  nixpkgs.config.allowUnfree = true;
}
