{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };

    profiles.alecs = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        # Needed
        ublock-origin
        # umatrix
        # bypass-paywalls-clean
        consent-o-matic
        facebook-container
        clearurls
        skip-redirect
        istilldontcareaboutcookies

        # Usability
        vimium
        darkreader
        bitwarden
        
        # Enhance
        lovely-forks
        nitter-redirect
        sponsorblock
        theater-mode-for-youtube
      ];

      settings = {
        "browser.startup.homepage" = "https://calendar.google.com/calendar/u/0/r";
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
  };
}
