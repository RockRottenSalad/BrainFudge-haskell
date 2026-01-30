module BrainFudge (parseProgram, runProgram) where 

import Data.Maybe
import Text.Printf (printf)
import qualified Zipper as Z
import Data.Char (ord)

-- BEGIN: TOKENIZER/PARSER
data Instruction = Add | Sub | ShiftLeft | ShiftRight | While [Instruction] | Print | Read
                   deriving Show

data Token = Plus | Minus | Less | Greater | BracketL | BracketR | Period | Comma
                deriving (Show, Eq)

isToken :: Char -> Bool
isToken = isJust . toToken

toToken :: Char -> Maybe Token
toToken '+' = Just Plus
toToken '-' = Just Minus
toToken '[' = Just BracketL
toToken ']' = Just BracketR
toToken '<' = Just Less
toToken '>' = Just Greater
toToken '.' = Just Period
toToken ',' = Just Comma
toToken _   = Nothing

parseInstructions :: [Token] -> ([Token], [Instruction])
parseInstructions [] = ([], [])
parseInstructions program = (remaining, reverse parsed) 
                            where
                            (remaining, parsed) 
                                = aux (program, [])
                                where
                                aux out@([], ins) = out
                                aux out@(full@(t:toks), ins) = 
                                    if t == BracketR 
                                    then (toks, ins)
                                    else aux (toks', in':ins)
                                        where
                                        (toks', in') = parseInstruction full

parseInstruction :: [Token] -> ([Token], Instruction)
parseInstruction [] = error "Empty"
parseInstruction (x:xs) = case x of
                            Plus -> (xs, Add)
                            Minus -> (xs, Sub)
                            Less -> (xs, ShiftLeft)
                            Greater -> (xs, ShiftRight)
                            Period -> (xs, Print)
                            Comma -> (xs, Read)
                            BracketL -> let
                                        (tokens, ins) = parseInstructions xs 
                                        in (tokens, While ins)
                            BracketR -> error "Extraneous ]"

parseProgram :: String -> [Instruction]
parseProgram [] = []
parseProgram program = snd $ parseInstructions $ mapMaybe toToken program

-- END: TOKENIZER/PARSER

-- BEGIN: INTERPRETER
runProgram' :: [Instruction] -> IO (Z.Zipper Int) -> IO (Z.Zipper Int)
runProgram' [] state = state
runProgram' (x:xs) state = state >>= \state ->
    runProgram' xs $
            case x of
                Add        -> return $ Z.modifyHead state (\x -> (x+1) `mod` 256)
                Sub        -> return $ Z.modifyHead state (\x -> if x==0 then 255 else x-1)
                ShiftLeft  -> return $ Z.left  state
                ShiftRight -> return $ Z.right state
                Print      -> printf "%c" (Z.head state) >> return state
                Read       -> getChar >>= \ch -> return $ Z.modifyHead state (\_ -> ord ch)
                While ins  -> whileLoop state
                              where
                              whileLoop state
                                 | Z.head state == 0 = return state
                                 | otherwise = runProgram' ins (return state) 
                                    >>= \state -> whileLoop state

runProgram :: [Instruction] -> IO()
runProgram ins = do
    runProgram' ins $ return (Z.fromList $ replicate 30000 0) 
    return ()

-- END: INTERPRETER
