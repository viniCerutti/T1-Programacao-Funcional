-------------------------------------------------------------------------
--  
--     Store.hs
--  
--         An abstract data type of stores of integers, implemented as
--         a list of pairs of variables and values.         
--                                  
--         (c) Addison-Wesley, 1996-2011.                   
--  
-------------------------------------------------------------------------

module Store 
   ( Store, 
     initial,     -- Store
     value,       -- Store -> Var -> Integer
     update,       -- Store -> Var -> Integer -> Store
     findSimTerms  -- Store -> Store -> Store
    ) where

-- Var is the type of variables.                    

type Var = Char

-- The implementation is given by a newtype declaration, with one
-- constructor, taking an argument of type [ (Integer,Var) ].

data Store = Store [ (Integer,Var) ] 

instance Eq Store where 
  (Store sto1) == (Store sto2) = (sto1 == sto2)                 

instance Show Store where
  showsPrec n (Store sto) = showsPrec n sto                 
--  
initial :: Store 

initial = Store []

value  :: Store -> Var -> Integer

value (Store []) v         = 0
value (Store ((n,w):sto)) v 
  | v==w            = n
  | otherwise       = value (Store sto) v

update  :: Store -> Var -> Integer -> Store

update (Store sto) v n = Store ((n,v):sto)


memory = initial
memory2 = initial

sto2 = update memory 'x' 9
sto3 = update sto2 'y' 10
sto4 = update sto3 'z' 11
sto5 = update sto4 'd' 12
sto10 = update sto5 'd' 45

sto6 = update memory2 'x' 13
sto7 = update sto6 'y' 14
sto8 = update sto7 'z' 15
sto9 = update sto7 'd' 16

-- metodo que retorna um store com os valores do primeiro store 
-- que estao contidos no segundo store
findSimTerms:: Store -> Store -> Store
findSimTerms (Store [])  store  = (Store [])
findSimTerms  store (Store []) =  store
findSimTerms (Store ((n1,w1):sto)) sto2
	|isterm w1 sto2 = update (findSimTerms (Store sto)  sto2) w1 n1
	| otherwise = findSimTerms (Store sto) sto2

	where 
		isterm:: Char -> Store -> Bool
		isterm _ (Store []) = False
		isterm carct (Store ((n,w):sto))
			| carct == w = True
			|otherwise = isterm carct (Store sto)