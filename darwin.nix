{ config, lib, pkgs, ... }:
let
  primaryUser = lib.escapeShellArg config.system.primaryUser;
  # `darwin-rebuild` runs as root since the 2025 activation rework, so any command that
  # touches the GUI session has to be re-entered into the primary user's launchd
  # bootstrap context. This matches what nix-darwin's own `userDefaults` phase does
  # (see modules/system/defaults-write.nix).
  asPrimaryUser = cmd: ''/bin/launchctl asuser "$primaryUserId" /usr/bin/sudo --user=${primaryUser} -- ${cmd}'';
in
{
  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postActivation.text = ''
      primaryUserId=$(/usr/bin/id -u -- ${primaryUser})

      # Flush the user's preferences daemon so the freshly written defaults (above, in the
      # `userDefaults` phase) are not served from cache when the UI processes restart.
      ${asPrimaryUser "/usr/bin/killall cfprefsd"} >/dev/null 2>&1 || true

      # activateSettings -u reloads the preferences database into the current GUI session.
      # It MUST run inside the primary user's launchd context, otherwise it operates on
      # root's empty session and silently does nothing.
      ${asPrimaryUser "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u"}

      # Restart UI services so changes to their respective domains take effect without a logout.
      # SystemUIServer owns the menu bar (clock, menu extras), Dock owns dock + Mission Control,
      # and Finder owns desktop + finder windows.
      ${asPrimaryUser "/usr/bin/killall SystemUIServer"} >/dev/null 2>&1 || true
      ${asPrimaryUser "/usr/bin/killall Dock"} >/dev/null 2>&1 || true
      ${asPrimaryUser "/usr/bin/killall Finder"} >/dev/null 2>&1 || true
    '';
    defaults = {
      menuExtraClock = {
        Show24Hour = true;
        ShowSeconds = true;
      };
      trackpad = {
        TrackpadThreeFingerDrag = true;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        orientation = "bottom";
        tilesize = 42;
        showhidden = true;
        show-recents = true;
        show-process-indicators = true;
        expose-animation-duration = 0.1;
        expose-group-apps = true;
        launchanim = false;
        mineffect = "genie";
        mru-spaces = false;
      };
      #   persistent-apps = [
      #     "/System/Applications/Fin.app"
      #     "/Applications/Firefox.app"
      #     "/System/Applications/Reminders.app"
      #     "/Applications/Anytype.app"
      #     "/System/Applications/Calendar.app"
      #     "/Applications/Ghostty.app"
      #     "/System/Applications/Mail.app"
      #     "/System/Applications/Messages.app"
      #     "/Applications/Discord.app"
      #     "/System/Applications/Music.app"
      #   ];
      # };
      NSGlobalDomain = {
        KeyRepeat = 2;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
      #   AppleShowScrollBars = "Always";
      #   NSWindowResizeTime = 0.1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      #   AppleInterfaceStyle = "Dark";
      #   NSDocumentSaveNewDocumentsToCloud = false;
        _HIHideMenuBar = true;
      #   "com.apple.springing.delay" = 0.0;
      };
      finder = {
        FXPreferredViewStyle = "Nlsv";
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
      };
      CustomUserPreferences = {
      #   "com.apple.NetworkBrowser" = {
      #     BrowseAllInterfaces = true;
      #   };
      #   "com.apple.screensaver" = {
      #     askForPassword = true;
      #     askForPasswordDelay = 0;
      #   };
      #   "com.apple.trackpad" = {
      #     scaling = 2;
      #   };
      #   "com.apple.mouse" = {
      #     scaling = 2.5;
      #   };
      #   "com.apple.desktopservices" = {
      #     DSDontWriteNetworkStores = false;
      #   };
      #   "com.apple.LaunchServices" = {
      #     LSQuarantine = true;
      #   };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          WarnOnEmptyTrash = false;
        };
        "NSGlobalDomain" = {
      #     NSNavPanelExpandedStateForSaveMode = true;
      #     NSTableViewDefaultSizeMode = 1;
      #     WebKitDeveloperExtras = true;
              SLSMenuBarUseBlurredAppearance = true;
        };
      #   "com.apple.ImageCapture" = {
      #     "disableHotPlug" = true;
      #   };
      #   "com.apple.mail" = {
      #     DisableReplyAnimations = true;
      #     DisableSendAnimations = true;
      #     DisableInlineAttachmentViewing = true;
      #     AddressesIncludeNameOnPasteboard = true;
      #     InboxViewerAttributes = {
      #       DisplayInThreadedMode = "yes";
      #       SortedDescending = "yes";
      #       SortOrder = "received-date";
      #     };
      #     NSUserKeyEquivalents = {
      #       Send = "@\U21a9";
      #       Archive = "@$e";
      #     };
      #   };
        "com.apple.dock" = {
          size-immutable = true;
        };
        # "com.apple.Safari" = {
        #   IncludeInternalDebugMenu = true;
        #   IncludeDevelopMenu = true;
        #   WebKitDeveloperExtrasEnabledPreferenceKey = true;
        #   ShowFullURLInSmartSearchField = true;
        #   AutoOpenSafeDownloads = false;
        #   HomePage = "";
        #   AutoFillCreditCardData = false;
        #   AutoFillFromAddressBook = false;
        #   AutoFillMiscellaneousForms = false;
        #   AutoFillPasswords = false;
        #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        #   AlwaysRestoreSessionAtLaunch = 1;
        #   ExcludePrivateWindowWhenRestoringSessionAtLaunch = 1;
        #   ShowBackgroundImageInFavorites = 0;
        #   ShowFrequentlyVisitedSites = 1;
        #   ShowHighlightsInFavorites = 1;
        #   ShowPrivacyReportInFavorites = 1;
        #   ShowRecentlyClosedTabsPreferenceKey = 1;
        # };
      };
    };
  };
}
