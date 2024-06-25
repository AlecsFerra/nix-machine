{ pkgs, ... }:
{

  xdg.mimeApps = {
    defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http"  = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  };

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
      id = 0;
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "https://calendar.google.com/calendar/u/0/r";
        "media.ffmpeg.vaapi.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
      };

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
        sponsorblock
        theater-mode-for-youtube
      ];

      bookmarks = [
        {
          name = "Mail";
          toolbar = true;
          bookmarks = [
            {
              name = "Gmail - Personale";
              url = "https://mail.google.com/mail/u/0/#inbox";
            }
            {
              name = "Gmail - UniPD";
              url = "https://mail.google.com/mail/u/1/#inbox";
            }
            {
              name = "Proton Mail";
              url = "https://mail.proton.me/u/0/inbox";
            }
          ];
        }
        {
          name = "Dev";
          toolbar = true;
          bookmarks = [
            {
              name = "GitHub";
              url = "https://github.com/";
            }
            {
              name = "Wolfram Alpha";
              url = "https://www.wolframalpha.com/";
            }
          ];
        }
        {
          name = "Nix";
          toolbar = true;
          bookmarks = [
            {
              name = "Home Manager Configuration Options";
              url = "https://nix-community.github.io/home-manager/options.xhtml";
            }
            {
              name = "NixOS packages";
              url = "https://search.nixos.org/packages";
            }
            {
              name = "NixOS options";
              url = "https://search.nixos.org/options";
            }
          ];
        }
        {
          name = "Research";
          toolbar = true;
          bookmarks = [
            {
              name = "PLS Lab";
              url = "https://www.pls-lab.org/";
            }
            {
              name = "Arxiv";
              url = "https://arxiv.org/";
            }
            {
              name = "nLab";
              url = "https://ncatlab.org/nlab/show/HomePage";
            }
          ];
        }
        {
          name = "Syncthing";
          url = "http://localhost:8384/";
        }
        {
          name = "YouTube";
          url = "https://www.youtube.com/";
        }
      ];

    };
  };
}
