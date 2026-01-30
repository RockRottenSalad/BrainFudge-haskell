module Zipper where

data Zipper a = Zipper [a] a [a] deriving Show

instance Functor Zipper where
    fmap f (Zipper ls x rs) = Zipper (map f ls) (f x) (map f rs)

fromList :: [a] -> Zipper a
fromList [] = error "Cannot be empty"
fromList (x:xs) = Zipper [] x xs

left :: Zipper a -> Zipper a
left (Zipper [] _ _) = error "Already at leftmost position" 
left (Zipper (l:ls) x rs) = Zipper ls l (x:rs)

right :: Zipper a -> Zipper a
right (Zipper _ _ []) = error "Already at rightmost position" 
right (Zipper ls x (r:rs)) = Zipper (x:ls) r rs

head :: Zipper a -> a
head (Zipper _ x _) = x

modifyHead :: Zipper a -> (a -> a) -> Zipper a
modifyHead (Zipper ls x rs) f = Zipper ls (f x) rs

