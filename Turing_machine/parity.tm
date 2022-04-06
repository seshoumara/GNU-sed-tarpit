#Author: seshoumara
#http://codegolf.stackexchange.com/users/59010/seshoumara

#Turing machine author: Christophe Blaess <ccb@club-internet.fr>
#http://sed.sourceforge.net/grabbag/scripts/turing.sed



#Program: prints if the integer number is odd or even


#tape initialization
|-1234

#State 0 (main): move head to the end of the input number
0--R0
000R0
011R0
022R0
033R0
044R0
055R0
066R0
077R0
088R0
099R0
0  Lp

#State p (parity): write "e" for even numbers, or "o" for odd numbers
p0eLr
p1oLr
p2eLr
p3oLr
p4eLr
p5oLr
p6eLr
p7oLr
p8eLr
p9oLr

#State r (remove): delete the minus sign and the digits
r- Lr
r0 Lr
r1 Lr
r2 Lr
r3 Lr
r4 Lr
r5 Lr
r6 Lr
r7 Lr
r8 Lr
r9 Lr
r  Rj

#State j (jump): jump to respective printing states dependent on parity
j  Rj
jooR1
jeeR3

#States 1 to 2: print "dd" and exit (state $)
1 dR2
2 d $

#States 3 to 5: print "ven" and exit (state $)
3 vR4
4 eR5
5 n $
