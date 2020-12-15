-- This is an example of how to use Data.Aeson to create a JSON decoder
-- that attempts several alternatives before failing. We create a PetInfo
-- that consists of either a PetName or PetAge, and the PetInfo FromJSON
-- instance attempts to decode each one before failing.
--
-- Run this example in ghci:
--
--   ghci decode-alternative.hs
--   > main
--   Right (PetInfoName (PetName "Jack"))
--   Right (PetInfoAge (PetAge 5))
--   Left "Error in $: Whoops! Can't parse PetInfo"

{-# LANGUAGE OverloadedStrings #-}

import           Control.Applicative
import           Data.Aeson
import           Data.Scientific
import           Data.Text

data PetName = PetName Text
    deriving Show

data PetAge = PetAge Int 
    deriving Show

data PetInfo
    = PetInfoName PetName
    | PetInfoAge PetAge
    deriving Show

instance FromJSON PetName where
    parseJSON (String s) =
        pure $ PetName s

    parseJSON _          =
        fail "Whoops! Can't parse PetName"

instance FromJSON PetAge where
    parseJSON (Number a) =
        case toBoundedInteger a of
            Just age ->
                pure $ PetAge age 

            Nothing  ->  
                fail "Whoops! Cant toBoundedInteger"

    parseJSON _          =
        fail "Whoops! Can't parse PetAge"

instance FromJSON PetInfo where
    parseJSON v = 
            PetInfoName <$> parseJSON v
        <|> PetInfoAge  <$> parseJSON v
        <|> fail "Whoops! Can't parse PetInfo"

main = do
    print $ (eitherDecode "\"Jack\"" :: Either String PetInfo)
    print $ (eitherDecode "5"        :: Either String PetInfo)
    print $ (eitherDecode "null"     :: Either String PetInfo)
