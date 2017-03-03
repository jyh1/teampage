{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Export where

import Text.Hamlet (shamletFile)
import Text.Blaze.Html.Renderer.String (renderHtml)
import Data.HashMap.Strict
import qualified Data.Text as T

import Parser

categoryTag = T.toUpper . T.replace "_" " "

getPeopleList :: HashMap T.Text [People] -> T.Text -> [People]
getPeopleList table tag = lookupDefault undefined tag table

generatePage :: PageInfo -> String
generatePage (PageInfo table) =
  renderHtml $(shamletFile "template.hamlet")

test = do
  p <- example
  return (generatePage p)
