module CsvReader
    ( parseConnections
    ) where

import Text.Parsec
import Text.Parsec.String (Parser)

type CsvLine = [String]

data Connection = Connection { name :: String, host :: String, login:: String} deriving (Show)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

parseCell :: Parser String
parseCell = many $ noneOf ";\n"

parseLine :: Parser CsvLine
parseLine = parseCell `sepBy` (char ';')

parseLines :: Parser [CsvLine]
parseLines = parseLine `sepEndBy` (char '\n')

mapToConnection :: CsvLine -> Connection
mapToConnection [name, host, login] = Connection name host login

parseConnections :: Either ParseError [Connection]
parseConnections = do 
    parseResult <- parse parseLines "" "zeg33ssh.plop.com (ihm);zeg33ssh.plop.com;Amuro\nzeg32ssh.plop.com (ihm);zeg32ssh.plop.com;Amuro" 
    return $ mapToConnection <$> parseResult