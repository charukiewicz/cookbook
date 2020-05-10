let
  defaultPkgs = import (builtins.fetchGit {
      url = https://github.com/NixOS/nixpkgs-channels;
      ref = "nixos-unstable";
      rev = "<nixpkgs_commit_hash>";
    }) {}; 
  # -OR-
  # defaultPkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/<nixpkgs_commit_hash>.tar.gz") {};
  # -OR-
  # defaultPkgs = import <nixpkgs> {};
in
{ pkgs ? defaultPkgs }:
  # This approach taken from a comment by /u/mightybyte: https://www.reddit.com/r/NixOS/comments/7h8np7/-/dqqpjpo/
  pkgs.haskellPackages.developPackage
    { root = ./.;
      overrides = self: super:
        { # Don't run a package's test suite
          # foo = pkgs.haskell.lib.dontCheck pkgs.haskellPackages.foo;
          #
          # Don't enforce package's version constraints
          # bar = pkgs.haskell.lib.doJailbreak pkgs.haskellPackages.bar;
          #
          # To discover more functions that can be used to modify haskell
          # packages, run "nix-repl", type "pkgs.haskell.lib.", then hit
          # <TAB> to get a tab-completed list of functions.
        };
      source-overrides =
        { # Use a specific hackage version
          # optparse-applicative = "0.14.0.0";
          #
          # Use a particular commit from github
          # my-private-package = pkgs.fetchFromGitHub
          #   { owner = "my-github-username";
          #     repo = "my-private-package";
          #     rev = "561de381bcccfe6792f2908a5022449a05ae0050";
          #     sha256 = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
          #   };
        };
    }
