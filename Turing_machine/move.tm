# Program: move value

# Author: seshoumara
# https://discord.gg/QqthWQzgkW


# tape initialization
|>9                 <

# State 0: start loop
0>>RD

# State D: decrement value of (current) cell
D98RI
D87RI
D76RI
D65RI
D54RI
D43RI
D32RI
D21RI
D1 RI

# State I: increment value of (next) cell
I 1LD
I12LD
I23LD
I34LD
I45LD
I56LD
I67LD
I78LD
I89 D
I<<Li

# State i: one last increment (D ran before <), then exit
i89R$
