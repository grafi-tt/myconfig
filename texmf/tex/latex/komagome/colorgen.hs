import Data.Colour.CIE (cieLAB)
import Data.Colour.CIE.Illuminant (d65)
import Data.Colour.SRGB (sRGB24show)
import System.Environment (getArgs)

main = do
  [l,a,b] <- map read <$> getArgs
  let col = cieLAB d65 l a b
  putStrLn . show . sRGB24show $ col
