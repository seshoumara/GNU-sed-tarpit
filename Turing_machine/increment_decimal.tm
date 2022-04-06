#Author: seshoumara
#http://codegolf.stackexchange.com/users/59010/seshoumara

#Turing machine author: Christophe Blaess <ccb@club-internet.fr>
#http://sed.sourceforge.net/grabbag/scripts/turing.sed



#Program: increments an integer number


#tape initialization
|99

#State 0 (main): jump dependent on the sign of the input number
0--Re
000RE
011RE
022RE
033RE
044RE
055RE
066RE
077RE
088RE
099RE

#State E (End): move head to the end of the positive number
E00RE
E11RE
E22RE
E33RE
E44RE
E55RE
E66RE
E77RE
E88RE
E99RE
E  LI

#State I (Increment): increment the positive number
I01 b
I12 b
I23 b
I34 b
I45 b
I56 b
I67 b
I78 b
I89 b
I90LI
I 1 b

#State e (end): move head to the end of the negative number
e00Re
e11Re
e22Re
e33Re
e44Re
e55Re
e66Re
e77Re
e88Re
e99Re
e  Li

#State i (increment): increment the negative number
i98 b
i87 b
i76 b
i65 b
i54 b
i43 b
i32 b
i21 b
i10 b
i09Li
i- Rc

#State c (correct): correct value after state i for special input case -0
c9 Rc
c 1 b

#State b (begin): move head to the begining of the incremented number
b00Lb
b11Lb
b22Lb
b33Lb
b44Lb
b55Lb
b66Lb
b77Lb
b88Lb
b99Lb
b- Rz
b  RZ

#State Z (zero): remove possible leading zeroes from malformed positive input number (optional)
Z11 t
Z22 t
Z33 t
Z44 t
Z55 t
Z66 t
Z77 t
Z88 t
Z99 t
Z0 RZ

#State z (zero): remove possible leading zeroes from malformed negative input number or after state i
z11Ls
z22Ls
z33Ls
z44Ls
z55Ls
z66Ls
z77Ls
z88Ls
z99Ls
z0 Rz
z 0 t

#State s (sign): add the minus sign in front of the result (removed before deleting leading zeroes)
s -Rt

#State t (terminate): move head to the end of the result and exit (state $)
t00Rt
t11Rt
t22Rt
t33Rt
t44Rt
t55Rt
t66Rt
t77Rt
t88Rt
t99Rt
t  L$
