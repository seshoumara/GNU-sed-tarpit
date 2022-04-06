#Author: seshoumara
#http://codegolf.stackexchange.com/users/59010/seshoumara

#Turing machine author: Christophe Blaess <ccb@club-internet.fr>
#http://sed.sourceforge.net/grabbag/scripts/turing.sed



#Program: converts text to uppercase


#tape initialization: character § is used to signal the end of the input text
|sed is awesome!§

#State 0 (main)
#change lowercase letters to uppercase
0aAR0
0bBR0
0cCR0
0dDR0
0eER0
0fFR0
0gGR0
0hHR0
0iIR0
0jJR0
0kKR0
0lLR0
0mMR0
0nNR0
0oOR0
0pPR0
0qQR0
0rRR0
0sSR0
0tTR0
0uUR0
0vVR0
0wWR0
0xXR0
0yYR0
0zZR0

#do not change these characters
0  R0
0!!R0
0""R0
0$$R0
0%%R0
0&&R0
0''R0
0((R0
0))R0
0**R0
0++R0
0,,R0
0--R0
0..R0
0//R0
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
0;;R0
0<<R0
0==R0
0>>R0
0??R0
0@@R0
0AAR0
0BBR0
0CCR0
0DDR0
0EER0
0FFR0
0GGR0
0HHR0
0IIR0
0JJR0
0KKR0
0LLR0
0MMR0
0NNR0
0OOR0
0PPR0
0QQR0
0RRR0
0SSR0
0TTR0
0UUR0
0VVR0
0WWR0
0XXR0
0YYR0
0ZZR0
0[[R0
0\\R0
0]]R0
0^^R0
0__R0
0``R0
0´´R0
0{{R0
0}}R0
0~~R0
0€€R0
0°°R0

#exit (state $)
0§ L$
