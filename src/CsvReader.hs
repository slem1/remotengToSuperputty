module CsvReader
    ( cell,
      line
    ) where

import Text.Parsec
import Text.Parsec.String (Parser)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

cell :: Parser String
cell = many $ noneOf ";\n"

line :: Parser [String]
line = cell `sepBy` (char ';') 
