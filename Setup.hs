import Control.Exception (SomeException, catch)
import Distribution.Simple
import System.Process

gitHash :: IO String
gitHash = do h <- Control.Exception.catch (readProcess "git" ["rev-parse", "--short", "HEAD"] "")
                  (\e -> let _ = (e :: SomeException) in return "PRE")
             return $ takeWhile (/= '\n') h

idrisConfigure :: a -> b -> c -> d -> IO ()
idrisConfigure _ _ _ _ = do
    hash <- gitHash
    putStrLn hash

main :: IO ()
main = defaultMainWithHooks $ simpleUserHooks
   { postConf  = idrisConfigure }
