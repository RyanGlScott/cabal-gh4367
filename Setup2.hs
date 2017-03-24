import Control.Monad
import Distribution.Simple
import Distribution.PackageDescription
import System.Process

idrisSDist sdist pkgDesc bi hooks flags = do
  pkgDesc' <- addGitFiles pkgDesc
  sdist pkgDesc' bi hooks flags
    where
      addGitFiles :: PackageDescription -> IO PackageDescription
      addGitFiles pkgDesc' = do
        files <- gitFiles
        return $ pkgDesc' { extraSrcFiles = extraSrcFiles pkgDesc' ++ files}
      gitFiles :: IO [FilePath]
      gitFiles = liftM lines ({-readProcess-} undefined "git" ["ls-files"] "")

main :: IO ()
main = defaultMainWithHooks $ simpleUserHooks
   { sDistHook = idrisSDist (sDistHook simpleUserHooks) }
