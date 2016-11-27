{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Exception (throwIO)
import Data.Aeson
import Data.ByteString.Char8 (pack)
import GHC.Generics
import Network.HTTP.Req
import System.Environment (getArgs, getEnv)

main :: IO ()
main = do
    [msg] <- getArgs
    slackUrl <- getEnv "MY_SLACK_URL"
    let body = Payload msg "Yoda" ":yoda:" "#general"
        Just (url, opt) = parseUrlHttps $ pack slackUrl
    res <- req POST url (ReqBodyJson body) bsResponse opt
    print $ responseStatusCode res

data Payload = Payload
    { text :: String
    , username :: String
    , icon_emoji :: String
    , channel :: String
    } deriving Generic

instance ToJSON Payload

instance MonadHttp IO where
    handleHttpException = throwIO
