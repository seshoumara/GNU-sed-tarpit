#Author: seshoumara
#http://codegolf.stackexchange.com/users/59010/seshoumara

#Turing machine author: Christophe Blaess <ccb@club-internet.fr>
#http://sed.sourceforge.net/grabbag/scripts/turing.sed



#Program: flips bits


#tape initialization
|10010111

#State 0 (main): flip one bit at a time and exit (state $)
001R0
010R0
0  L$
