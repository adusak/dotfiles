{ pkgs, ... }:
{
  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
    defaults = {
      menuExtraClock = {
        Show24Hour = true;
        ShowSeconds = true;
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
      # NSGlobalDomain = {
      #   ApplePressAndHoldEnabled = false;
      #   KeyRepeat = 2;
      #   InitialKeyRepeat = 15;
      #   AppleShowScrollBars = "Always";
      #   NSWindowResizeTime = 0.1;
      #   NSAutomaticCapitalizationEnabled = false;
      #   NSAutomaticDashSubstitutionEnabled = false;
      #   NSAutomaticPeriodSubstitutionEnabled = false;
      #   NSAutomaticQuoteSubstitutionEnabled = false;
      #   NSAutomaticSpellingCorrectionEnabled = false;
      #   AppleInterfaceStyle = "Dark";
      #   NSDocumentSaveNewDocumentsToCloud = false;
      #   _HIHideMenuBar = false;
      #   "com.apple.springing.delay" = 0.0;
      # };
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
      #   "com.apple.finder" = {
      #     ShowExternalHardDrivesOnDesktop = false;
      #     ShowRemovableMediaOnDesktop = false;
      #     WarnOnEmptyTrash = false;
      #   };
      #   "NSGlobalDomain" = {
      #     NSNavPanelExpandedStateForSaveMode = true;
      #     NSTableViewDefaultSizeMode = 1;
      #     WebKitDeveloperExtras = true;
      #   };
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
