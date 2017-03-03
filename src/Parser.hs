{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Parser where

import Data.Text (Text)
import qualified Data.Yaml as Y
import Data.Yaml (FromJSON(..), (.:))
import Data.ByteString (ByteString)
import Control.Applicative
import GHC.Generics
import Data.HashMap.Strict
import qualified Data.ByteString.Lazy as B


data People =
  People {
    familyName :: Text
  , givenName :: Text
  , titles :: Maybe [Text]
  , url :: Maybe Text
  , descriptions :: [Text]
  , email :: Text
  , photo :: Maybe Text
  } deriving (Eq, Show, Generic)

instance FromJSON People

data PageInfo = PageInfo (HashMap Text [People])
  deriving (Eq, Show)

instance FromJSON PageInfo where
  parseJSON (Y.Object v) =
    PageInfo <$>
      mapM parseJSON v

-- for test
example :: IO PageInfo
example = do
  p <- Y.decodeFileEither "example.yaml"
  case p of
    Right i -> return i
