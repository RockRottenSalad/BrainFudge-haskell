module Main where

import qualified BrainFudge as BF
import System.Directory (doesFileExist)
import System.Environment (getArgs)

main :: IO()
main = do
    args <- getArgs

    programSource <- 
            if null args
            then getContents
            else doesFileExist (head args) >>= \fileExists ->
                    if fileExists
                    then readFile $ head args
                    else error "File not found"

    let instructions = BF.parseProgram programSource
    BF.runProgram instructions

