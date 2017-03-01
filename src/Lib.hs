{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveGeneric #-}

module Lib
    ( someFunc
    ) where

import Data.Text (Text)
import qualified Data.Yaml as Y
import Data.Yaml (FromJSON(..), (.:))
import Text.RawString.QQ
import Data.ByteString (ByteString)
import Control.Applicative
import Prelude -- Ensure Applicative is in scope and we have no warnings, before/after AMP.
import GHC.Generics

configYaml :: ByteString
configYaml = [r|
resolver: lts-3.7
packages:
  - ./yesod-core
  - ./yesod-static
  - ./yesod-persistent
  - ./yesod-newsfeed
  - ./yesod-form
  - ./yesod-auth
  - ./yesod-auth-oauth
  - ./yesod-sitemap
  - ./yesod-test
  - ./yesod-bin
  - ./yesod
  - ./yesod-eventsource
  - ./yesod-websockets
# Needed for LTS 2
extra-deps:
- wai-app-static-3.1.4.1
test:
  familyName: wang
  lastName: newb
  titles:
    - Principle
  descriptions:
    - |
        haha
        heheh
        yes
        new: sldkfj
    - "Job Description: Daily Management"
  email: "wang@newbie.com"
  photo: "www.baidu.com"
|]

data Config =
  Config {
    resolver  :: Text
  , packages  :: [FilePath]
  , extraDeps :: [Text]
  , test :: People
  } deriving (Eq, Show)

data People =
  People {
    familyName :: Text
  , lastName :: Text
  , titles :: [Text]
  , url :: Maybe Text
  , descriptions :: [Text]
  , email :: Text
  , photo :: Text
  } deriving (Eq, Show, Generic)

instance FromJSON People


instance FromJSON Config where
  parseJSON (Y.Object v) =
    Config <$>
    v .:   "resolver"       <*>
    v .:   "packages" <*>
    v .:   "extra-deps" <*>
    v .: "test"
  parseJSON _ = fail "Expected Object for Config value"

someFunc :: IO ()
someFunc =
  print $ (Y.decode configYaml :: Maybe Config)
