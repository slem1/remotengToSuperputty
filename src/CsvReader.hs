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

mapToConnections :: [CsvLine] -> [Maybe Connection]
mapToConnections xs = mapToConnection <$> xs
      where mapToConnection (name:_:_:_:description:_:panel:username:hostname:xs) = Just (Connection name description panel username hostname)
            mapToConnection _ = Nothing

parseConnections :: FilePath -> ExceptT ParseError IO [Maybe Connection]
parseConnections inputFile = ExceptT $ do 
    content <- readFile inputFile
   -- putStrLn content
    let parsedLines = parse csvParser "" content
    return $ liftM mapToConnections parsedLines 
