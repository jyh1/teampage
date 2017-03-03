{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Parser where

import Data.Text (Text)
import qualified Data.Yaml as Y
import Data.Yaml (FromJSON(..), (.:))
import Data.ByteString (ByteString)
import Control.Applicative
import GHC.Generics
import qualified Data.HashMap.Strict as H
import qualified Data.ByteString.Lazy as B
import Data.Maybe


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

data Category = Category Text [People]
  deriving (Eq, Show)

instance FromJSON Category where
  parseJSON (Y.Object v) =
    let k = head (H.keys v) in
      Category k <$> parseJSON (fromJust $ H.lookup k v)

data PageInfo = PageInfo [Category]
  deriving (Eq, Show, Generic)


instance FromJSON PageInfo


-- for test
example :: IO PageInfo
example = do
  p <- Y.decodeFileEither "example.yaml"
  case p of
    Right i -> return i
