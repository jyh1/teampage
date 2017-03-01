{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

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
  name: wang
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
    name :: Text
  , photo :: Text
  } deriving (Eq, Show)

instance FromJSON People where
  parseJSON (Y.Object v) =
    People <$>
    v .: "name" <*>
    v .: "photo"

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
