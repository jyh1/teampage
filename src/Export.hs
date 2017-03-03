{-# LANGUAGE TemplateHaskell #-}
module Export where

import Text.Hamlet (shamletFile)
import Text.Blaze.Html.Renderer.String (renderHtml)


test :: String
test = renderHtml $(shamletFile "template.hamlet")
