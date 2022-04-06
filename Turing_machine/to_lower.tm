#Author: seshoumara
#http://codegolf.stackexchange.com/users/59010/seshoumara

#Turing machine author: Christophe Blaess <ccb@club-internet.fr>
#http://sed.sourceforge.net/grabbag/scripts/turing.sed



#Program: converts text to lowercase


#tape initialization: character § is used to signal the end of the input text
|SED IS AWESOME!§

#State 0 (main)
#change uppercase letters to lowercase
0AaR0
0BbR0
0CcR0
0DdR0
0EeR0
0FfR0
0GgR0
0HhR0
0IiR0
0JjR0
0KkR0
0LlR0
0MmR0
0NnR0
0OoR0
0PpR0
0QqR0
0RrR0
0SsR0
0TtR0
0UuR0
0VvR0
0WwR0
0XxR0
0YyR0
0ZzR0

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
0[[R0
0\\R0
0]]R0
0^^R0
0__R0
0``R0
0´´R0
0aaR0
0bbR0
0ccR0
0ddR0
0eeR0
0ffR0
0ggR0
0hhR0
0iiR0
0jjR0
0kkR0
0llR0
0mmR0
0nnR0
0ooR0
0ppR0
0qqR0
0rrR0
0ssR0
0ttR0
0uuR0
0vvR0
0wwR0
0xxR0
0yyR0
0zzR0
0{{R0
0}}R0
0~~R0
0€€R0
0°°R0

#exit (state $)
0§ L$
