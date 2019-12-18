module CsvReader
    ( parseConnections
    ) where

import Text.Parsec
import Text.Parsec.String (Parser)
import Control.Monad

type CsvLine = [String]

data Connection = Connection { name :: String, host :: String, login:: String} deriving (Show)

sampleContent = "name;host;login\nzeg33ssh.plop.com (ihm);zeg33ssh.plop.com;Amuro\nzeg32ssh.plop.com (ihm);zeg32ssh.plop.com;Amuro" 

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
      where mapToConnection [name, host, login] = Connection name host login

parseConnections :: FilePath -> IO (Either ParseError [Connection])
parseConnections inputFile = do 
    content <- readFile inputFile
    let parsedLines = parse csvParser "" content
    return $ liftM mapToConnections parsedLines 