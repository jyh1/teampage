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
import Data.HashMap.Strict

configYaml :: ByteString
configYaml = [r|
faculties:
  - familyName: wang
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

  - familyName: wang
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

staff:
  - familyName: wang
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

data PageInfo = PageInfo (HashMap Text [People])
  deriving (Eq, Show)

instance FromJSON PageInfo where
  parseJSON (Y.Object v) =
    PageInfo <$>
      mapM parseJSON v


someFunc :: IO ()
someFunc =
  print $ (Y.decode configYaml :: Maybe PageInfo)
