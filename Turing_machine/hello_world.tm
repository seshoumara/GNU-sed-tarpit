#Author: seshoumara
#http://codegolf.stackexchange.com/users/59010/seshoumara

#Turing machine author: Christophe Blaess <ccb@club-internet.fr>
#http://sed.sourceforge.net/grabbag/scripts/turing.sed



#Program: prints "Hello World!"


#tape initialization: start with a default blank tape

#States 0 to 9 and A to B: print "Hello World!" one character at a time and exit (state $)
0 HR1
1 eR2
2 lR3
3 lR4
4 oR5
5  R6
6 WR7
7 oR8
8 rR9
9 lRA
A dRB
B ! $
