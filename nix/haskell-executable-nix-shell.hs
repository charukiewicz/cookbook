#!/usr/bin/env nix-shell
#!nix-shell -i runghc -p "with import <nixpkgs> { }; haskellPackages.ghcWithPackages (pkgs: with pkgs; [ HTTP tagsoup ])"
#!nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-22.05.tar.gz

import           Network.HTTP
import           Text.HTML.TagSoup

main = do
  resp <- Network.HTTP.simpleHTTP (getRequest "http://nixos.org/")
  body <- getResponseBody resp
  let tags = filter (isTagOpenName "a") $ parseTags body
  let tags' = map (fromAttrib "href") tags
  mapM_ putStrLn $ filter (/= "") tags'
