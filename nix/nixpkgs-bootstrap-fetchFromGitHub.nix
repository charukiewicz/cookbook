# In this recipe, we're going to bootstrap a nixpkgs import using whatever
# is available on the system (so long as we're on NixOS or Nix is installed)
# Using this technique, we can invoke nixpkgs functions that aren't defined
# in the `builtins`.
#
# Why do this? One reason is system cleanliness. The `builtins.fetchGit`
# function produces a large artifact in ~/.cache/nix/gitv2 that can be
# several GB in size when cloning nixpkgs, and this is not cleaned up
# when running `nix-collect-garbage`. Using `pkgs.fetchFromGitHub`,
# by contrast, does not create this artifact and only writes to /nix/store.

let

  # Import a version of nixpkgs based off of what's available in the NIX_PATH.
  # This is likely to change as the Nix channels on the system get updated,
  # so we'll only use this to access the fetchFromGitHub function, which isn't
  # available in our builtins.
  bootstrap = import <nixpkgs> {};

  # Use the bootstrapped nixpkgs import to call fetchFromGitHub on the pinned
  # version of nixpkgs.
  pkgsPin = bootstrap.fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixpkgs";
    rev = "bc260badaebf67442befe20fb443034d3a91f2b3";
    sha256 = "1iysc4xyk88ngkfb403xfq5bs3zy29zfs83pn99kchxd45nbpb5q";
  };

  # Import the pinned nixpkgs.
  pkgs = import pkgsPin {};
  
in
  pkgs
