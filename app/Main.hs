module Main where

import CsvReader
import XmlWriter
import System.Environment
import Connection
import qualified Data.ByteString.Lazy as BSL
import Control.Monad.Trans.Except
import Text.Parsec

--main :: IO ()
main = do
    args <- getArgs
    case args of 
        [inputFile, outputFile] -> do 
            result <- runExceptT $ parseConnections inputFile                            
            case result of 
                Left err -> error $ show err
                Right cnxs -> 
                    let out = renderConnections cnxs in
                    BSL.writeFile outputFile out
        _ -> error "Usage: app \"inputFile\" \"outputFile\""

--main =     
--    (runExceptT $ parseConnections "/home/slemoine/dev/workspace/remotengToSuperputty/import.csv") >>= \result -> case result of
--        Left x -> putStrLn "error"
--        Right x -> putStrLn $ show x
    

            
