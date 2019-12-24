module Connection (
    Connection(Connection, name, description, environment, username, hostname)
 ) where


data Connection = Connection { name :: String, 
                               description :: String, 
                               environment :: String, 
                               username :: String, 
                               hostname :: String
                               } deriving (Show)