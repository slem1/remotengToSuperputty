module Main where

import CsvReader
import XmlWriter
import System.Environment
import Connection
import qualified Data.ByteString.Lazy as BSL
import Control.Monad.Trans.Except
import Text.Parsec

main :: IO ()
main = do
    args <- getArgs
    case args of 
        [inputFile, outputFile] -> do 
            result <- runExceptT $ do
                cnxs <- parseConnections inputFile            
                let out = renderConnections cnxs
                return $ BSL.writeFile outputFile out
            case result of 
                Left error -> putStrLn $ show error   
                _ -> putStrLn "Done!"
        _ -> error "Usage: app \"inputFile\" \"outputFile\""
            
