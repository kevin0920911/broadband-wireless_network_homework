-- generate infinite prime list
primes :: [Integer]
primes = filterPrime [2..] where 
    -- recursively remove composite number and append new prime
    filterPrime(p:xs) = p : filterPrime [x | x <- xs, x `mod` p /= 0] 
    
main :: IO ()
main = do 
    -- get sub-array of preimes while the number <= 1000 
    let res = takeWhile (<=1000) primes
        -- and let this list to string and let the string list to output
        output = unlines (map show res)
    writeFile "prime.txt" output 