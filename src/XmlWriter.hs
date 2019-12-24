module XmlWriter (
    renderConnections
) where

import Text.XML.Generator
import qualified Data.Text as T
import qualified Data.ByteString.Lazy as BSL
import Connection


renderConnections :: [Connection] -> BSL.ByteString
renderConnections cnxs = xrender ( buildDoc cnxs )

buildDoc :: [Connection] -> Xml Doc
buildDoc cnxs = doc defaultDocInfo $ root cnxs                             
    where root cnxs = arrayOfSessionData . xelems $ children cnxs
          arrayOfSessionData :: AddChildren c => c -> Xml Elem
          arrayOfSessionData = xelem $ T.pack $ "ArrayOfSessionData"
          children cnxs = fmap connectionToSessionData cnxs 

connectionToSessionData :: Connection -> Xml Elem
connectionToSessionData c = xelem (T.pack "SessionData") $ xattrs [
    xattr (T.pack "SessionId") $ T.pack $ path c,
    xattr (T.pack "SessionName") $ T.pack $ Connection.name c, 
    xattr (T.pack "Host") $ T.pack $ Connection.hostname c, 
    xattr (T.pack "Port") $ T.pack "22", 
    xattr (T.pack "Proto") $ T.pack "SSH"]
    where path c = environment c ++ "/" ++ name c 