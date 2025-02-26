# Program: increment binary number

# Author: seshoumara
# https://discord.gg/QqthWQzgkW


# tape initialization
|10010111

# State 0: move head to end of input
000R0
011R0
0  LI

# State I: increment binary number, then exit
I01 $
I10LI
I 1 $
