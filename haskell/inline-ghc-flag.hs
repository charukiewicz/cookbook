-- Set a GHC flag for a single source file.
--
-- Ex: Disable warnings in a specific module.

{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

main :: IO ()
main = putStrLn "Hello, world"
