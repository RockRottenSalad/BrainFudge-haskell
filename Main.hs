module Main where

import qualified BrainFudge as BF

main :: IO()
main = do
    let x = BF.parseProgram "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
    BF.runProgram x

