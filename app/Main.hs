module Main where

import CsvReader
import XmlWriter
import System.Environment
import Connection
import qualified Data.ByteString.Lazy as BSL

main :: IO ()
main = do
    args <- getArgs
    case args of 
        [inputFile, outputFile] -> do
            cnxs <- parseConnections inputFile            
            let Right out = cnxs >>= \x -> return $ renderConnections x
            BSL.writeFile outputFile out
        _ -> error "Usage: app \"inputFile\" \"outputFile\""
            
