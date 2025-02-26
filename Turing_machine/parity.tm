# Program: print if the integer number is odd or even

# Author: seshoumara
# https://discord.gg/QqthWQzgkW


# tape initialization
|-1234

# State 0: move head to the end of the input number
0--R0
0++R0
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

# State p: parity check (write "e" for even, "o" for odd)
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

# State r: remove starting digits and the sign (if any), then exit
r-  r
r+  r
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
r  R$
