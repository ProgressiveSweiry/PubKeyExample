import Crypto.PubKey.ECDSA as ECDSA
import Crypto.ECC
import Crypto.Hash
import Crypto.Error
import Crypto.Random.Types
import Data.ByteArray
import Data.Proxy
import Data.ByteString
import Data.ByteArray.Encoding
import qualified Data.ByteString.Char8 as C8
import qualified Data.ByteString.UTF8 as UTF8
import Data.Either
import Data.List as L
import System.Environment


-- Enum For Getting Key From Pair Tuple
data GetKey = Private | Public deriving Eq
type Pair = (ByteString, ByteString) 


{-
- Get help command --help
- Generate (PrivateKey,PublicKey) -g (only output) genF *
- Generate PublicKey from existing PrivateKey  (PrivateKey input) *
- Generate PrivateKey only  (only output) * 
- Sign message with existing PrivateKey -m (PrivateKey, String input) mesF -
- Verify message with existring PublicKey  (PublicKey, String input) -
-}

main :: IO()
main = do
    args <- getArgs
    if "-h" `L.elem` args || "--help" `L.elem` args
    then do
        p "--help To Print This Message"
        p "-g To Generate Keys"
        p "-m To Sign / Verify Messages" 
    else if "-g" `L.elem` args 
         then genF
         else if "-m" `L.elem` args
              then mesF
              else p "Try -h or --help" 


-- Function For Key Generation
genF :: IO()
genF = do
    p "Generate [ keypair | private | public ] ?"
    p " "
    command <- r 
    if 'k' `L.elem` command
    then do
        pair <- createEncodedKeys
        p "Private Key (Keep Secret): "
        p " "
        p $ toBase16 $ getKeyFromPair Private pair
        p " "
        p "Public Key:"
        p " "
        p $ toBase16 $ getKeyFromPair Public pair 
        p " "
    else if 'v' `L.elem` command 
         then do 
             pair <- createEncodedKeys
             p "Private Key (Keep Secret): "
             p " "
             p $ toBase16 $ getKeyFromPair Private pair
             p " "
         else do
              p "Enter Private Key: "
              p " "
              pubK <- r 
              p " " 
              p "Public Key: "
              p " "
              p $ toBase16 $ generatePublic $ toByteString pubK
              p " "

-- Function For Sign/Verify Message
mesF :: IO()
mesF = do
    p "Sign Or Verify Message [ sign | verify ] ?"
    p " "
    command <- r
    if 's' `L.elem` command
        then do
            p "Enter Private Key: "
            p " "
            priv <- r
            p " "
            p "Enter Message: "
            p " "
            msg <- r
            p " "
            sig <- signStringMsg (toByteString priv) msg
            printSignatureInteger sig
            p " "
        else if  'v' `L.elem` command
             then do 
                 p "Enter Public Key: "
                 p " "
                 pub <- r
                 p " "
                 p "Enter Message: "
                 p " "
                 msg <- r
                 p " "
                 p "Enter First Signature Integer: "
                 p " "
                 sig1 <- r
                 p " "
                 p "Enter Second Signature Integer: "
                 p " "
                 sig2 <- r
                 let sig = readSignatureInteger (read sig1 :: Integer)  (read sig2 :: Integer)
                 p " " 
                 p $ show $ verifyStringMsg (toByteString pub) sig msg
                 p " "
             else p "No Args!"
             


p :: String -> IO()
p = Prelude.putStrLn

r :: IO (String)
r = Prelude.getLine

-- Converting Key To Hexadecimal
toBase16 :: ByteString -> String
toBase16 bs = UTF8.toString (convertToBase Base16 bs :: ByteString)

-- Converting Key From Hexadecimal
toByteString :: String -> ByteString
toByteString s = fromRight (C8.pack "ERROR") (convertFromBase Base16 (C8.pack s) :: Either String ByteString)

-- proxy holding curve needed for generating keys
-- curves can be found on https://hackage.haskell.org/package/cryptonite-0.29/docs/Crypto-ECC.html#v:curveGenerateKeyPair
proxy :: Proxy Curve_P521R1
proxy = Proxy :: Proxy (Curve_P521R1)

-- (Private, Public) Keys Generation
createEncodedKeys :: IO Pair
createEncodedKeys = do
    keypair <- curveGenerateKeyPair proxy
    let pubKey = keypairGetPublic keypair
    let privKey = keypairGetPrivate keypair
    let privE = encodePrivate proxy privKey :: ByteString
    let pubE = encodePublic proxy pubKey :: ByteString
    return (privE, pubE)

-- Extract Key from Pair 
getKeyFromPair :: GetKey -> Pair -> ByteString
getKeyFromPair gk (priv, pub)
    | gk == Private = priv
    | otherwise = pub

-- Print Private Key in Hexadecimal
printPriv16 :: Pair -> IO ()
printPriv16 p = do
    print $ toBase16 $ getKeyFromPair Private p

-- Print Public Key in Hexadecimal
printPub16 :: Pair -> IO ()
printPub16 p = do
    print $ toBase16 $ getKeyFromPair Public p

-- Generate PublicKey using PrivateKey
generatePublic :: ByteString -> ByteString
generatePublic priv = encodePublic proxy (toPublic proxy dPriv)
    where
        dPriv = throwCryptoError (decodePrivate proxy priv)

-- Sign string message using PrivateKey
signStringMsg :: (MonadRandom m) => ByteString -> String -> m (Signature Curve_P521R1)
signStringMsg priv msg = sign proxy dPriv SHA256 eMsg
    where
        dPriv = throwCryptoError (decodePrivate proxy priv)
        eMsg  = C8.pack msg

-- Verify if string message was signed with matching PrivateKey (Function gets PublicKey)
verifyStringMsg :: ByteString -> (Signature Curve_P521R1) -> String -> Bool
verifyStringMsg pub sig msg = verify proxy SHA256 dPub sig eMsg
    where
        dPub = throwCryptoError (decodePublic proxy pub)
        eMsg = C8.pack msg

-- Print the (R,S) product of given Signature
printSignatureInteger :: (Signature Curve_P521R1) -> IO ()
printSignatureInteger sig = do
    let i = signatureToIntegers proxy sig
    let r = (\(l,r) -> l) i
    let s = (\(l,r) -> r) i
    p "Signature Integers In Order (BOTH NEEDED FOR VERIFICATION):"
    p " "
    p $ show r
    p " "
    p $ show s

-- Constructing (R,S) Integers back to Signature
readSignatureInteger :: Integer -> Integer -> (Signature Curve_P521R1)
readSignatureInteger r s = throwCryptoError $ signatureFromIntegers proxy (r,s)


















