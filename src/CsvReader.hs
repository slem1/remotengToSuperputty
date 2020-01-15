module CsvReader
    ( parseConnections
    ) where

import Text.Parsec
import Text.Parsec.String (Parser)
import Control.Monad
import Connection
import Control.Monad.Trans.Except

type CsvLine = [String]

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
      where mapToConnection (name:_:_:_:description:_:panel:username:hostname:xs) = Connection name description panel username hostname

parseConnections :: FilePath -> ExceptT ParseError IO [Connection]
parseConnections inputFile = ExceptT $ do 
    content <- readFile inputFile
    let parsedLines = parse csvParser "" content
    return $ liftM mapToConnections parsedLines 
