module CsvReader
    ( parseConnections,
      readAndPrintConnections
    ) where

import Text.Parsec
import Text.Parsec.String (Parser)
import Control.Monad

type CsvLine = [String]

data Connection = Connection { name :: String, 
                               description :: String, 
                               category :: String, 
                               username :: String, 
                               hostname :: String
                               } deriving (Show)

parseCell :: Parser String
parseCell = many $ noneOf ";\n"

parseLine :: Parser CsvLine
parseLine = parseCell `sepBy` (char ';')

parseLines :: Parser [CsvLine]
parseLines = parseLine `sepEndBy` (char '\n')

csvParser :: Parser [CsvLine]
csvParser =  (manyTill anyChar newline >> parseLines)

mapToConnections :: [CsvLine] -> [Connection]
mapToConnections xs = mapToConnection <$> xs
      where mapToConnection (name:_:_:_:description:_:panel:username:_:_:hostname:xs) = Connection name description panel username hostname

parseConnections :: FilePath -> IO (Either ParseError [Connection])
parseConnections inputFile = do 
    content <- readFile inputFile
    let parsedLines = parse csvParser "" content
    return $ liftM mapToConnections parsedLines 

readAndPrintConnections :: FilePath -> IO ()
readAndPrintConnections inputFile = do
    connections <-  parseConnections inputFile
    print connections