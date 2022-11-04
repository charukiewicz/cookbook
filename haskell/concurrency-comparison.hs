#!/usr/bin/env nix-shell
#!nix-shell -i runghc -p "with import <nixpkgs> { }; haskellPackages.ghcWithPackages (pkgs: with pkgs; [ wreq bytestring async time ])"
#!nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-22.05.tar.gz

-- Do not remove the above lines. Run this file as an executable:
--
--   chmod a+x ./Main.hs && ./Main.hs
--
-- The nix utility must be installed for this to work. 

import           Control.Concurrent.Async
import           Control.Lens
import           Data.ByteString.Lazy     ( ByteString )
import qualified Data.ByteString.Lazy     as BS
import           Data.Time.Clock
import           GHC.Int
import           Network.Wreq


getFromUrl :: String -> IO ByteString
getFromUrl url = do
    response <- get url 
    pure (response ^. responseBody)


loadRssFeedsSync :: IO [ByteString]
loadRssFeedsSync = do
    source1 <- getFromUrl "https://foxhound.systems/blog/rss.xml"
    source2 <- getFromUrl "https://reddit.com/r/haskell.rss"
    source3 <- getFromUrl "https://discourse.haskell.org/latest.rss"
    pure [source1, source2, source3]


loadRssFeedsAsync :: IO [ByteString]
loadRssFeedsAsync = do
    let dataUrls = [ "https://foxhound.systems/blog/rss.xml"
                   , "https://reddit.com/r/haskell.rss"
                   , "https://discourse.haskell.org/latest.rss"
                   ]   

    forConcurrently dataUrls getFromUrl

sumLength :: [ByteString] -> Int64
sumLength =
    foldr ((+) . BS.length) 0

main :: IO ()
main = do
    preAsync <- getCurrentTime
    rssFeedDataAsync <- loadRssFeedsAsync
    postAsync <- getCurrentTime

    let asyncTime = diffUTCTime postAsync preAsync
    putStrLn $ "Feed length (async): " <> show (sumLength rssFeedDataAsync)
    putStrLn $ "Async request time: " <> show asyncTime

    preSync <- getCurrentTime
    rssFeedDataSync <- loadRssFeedsSync
    postSync <- getCurrentTime

    let syncTime = diffUTCTime postSync preSync
    putStrLn $ "Feed length (sync): " <> show (sumLength rssFeedDataSync)
    putStrLn $ "Sync request time: " <> show syncTime

    putStrLn $ "Concurrency advantage: " <> show (syncTime - asyncTime)
