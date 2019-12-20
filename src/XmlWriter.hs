module XmlWriter (
    renderIt

) where

import Text.XML.Generator
import qualified Data.Text as T
import qualified Data.ByteString.Lazy as BSL

data Connection = Connection { name :: String, 
                               description :: String, 
                               category :: String, 
                               username :: String, 
                               hostname :: String
                               } deriving (Show)

arrayOfSessionData :: AddChildren c => c -> Xml Elem
arrayOfSessionData = xelem $ T.pack $ "ArrayOfSessionData"

connectionToSessionData :: Connection -> Xml Elem
connectionToSessionData c = xelem (T.pack "SessionData") $ xattrs [
    xattr (T.pack "SessionId") $ T.pack (name c),
    xattr (T.pack "SessionName") $ T.pack (name c), 
    xattr (T.pack "Host") $ T.pack (hostname c), 
    xattr (T.pack "Port") $ T.pack "22", 
    xattr (T.pack "Proto") $ T.pack "SSH"] 


myTestFunc = let people = [("Stefan", "32"), ("Judith", "4")] 
             in doc defaultDocInfo (xelem (T.pack ("people")) noElems) 
                
renderIt :: IO ()
renderIt = BSL.putStrLn $ xrender myTestFunc