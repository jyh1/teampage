{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Export where

import Text.Hamlet (shamletFile)
import Text.Blaze.Html.Renderer.String (renderHtml)
import Data.HashMap.Strict
import qualified Data.Text as T
import Data.Maybe

import Parser

categoryTag = T.toUpper . T.replace "_" " "

getFamilyName = T.toUpper . familyName

getGivenName p =
  let given = T.toLower $ givenName p
      (h, r) = T.splitAt 1 given
  in
    T.append (T.toUpper h) r

getWholeName p =
  T.append (getGivenName p) (T.cons ' ' $ getFamilyName p)

getUrl :: People -> T.Text
getUrl = fromMaybe "void" . url

getNameLine p =
  T.intercalate ", " (getWholeName p : titles p)

getPeopleList :: HashMap T.Text [People] -> T.Text -> [People]
getPeopleList table tag = lookupDefault undefined tag table

generatePage :: PageInfo -> String
generatePage (PageInfo table) =
  renderHtml $(shamletFile "template.hamlet")

test = do
  p <- example
  return (generatePage p)
