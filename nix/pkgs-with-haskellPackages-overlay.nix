let
  # Pin a version of nixpkgs
  pkgsPin = { 
      url = "https://github.com/NixOS/nixpkgs.git";
      ref = "nixos-20.09";
      rev = "bc260badaebf67442befe20fb443034d3a91f2b3";
    };  

  # Pin a version of all-cabal-hashes (pinned version must contain everything
  # on hackage that will be in the overlay, otherwise packages won't build)
  allCabalHashesPin = { 
      url = "https://github.com/commercialhaskell/all-cabal-hashes/archive/d0c3ae79467b4fe133ff864b6d6c0459d8a25bdb.tar.gz";
      sha256 = "0gzkkajqjhm2i1aw41y7p26yrzkpm2mxvv2mrgi0r2l161nsp7pv";
    };  

  # Import nixpkgs based off of the pinned version, but include haskellOverlay
  pkgs = import (builtins.fetchGit pkgsPin) {
      config = {}; 
      overlays = [ haskellOverlay ];
    };  

  # Overlay select items in pkgs.haskellPackages and also use the pinned
  # version of all-cabal-hashes
  haskellOverlay = self: super: {
      haskellPackages = (pkgs_: pkgs_.haskellPackages.override {
        overrides = self_: super_: rec {
          hakyll =
            pkgs_.haskell.lib.dontCheck
              (self_.callHackage "hakyll" "4.13.4.1" {});

          hakyll-sass =
            pkgs_.haskell.lib.dontCheck
              (self_.callHackage "hakyll-sass" "0.2.4" {});

        };
      }) super;

      all-cabal-hashes = builtins.fetchurl allCabalHashesPin;
    };  
in
  pkgs
