# Program: increment integer number

# Author: seshoumara
# https://discord.gg/QqthWQzgkW


# tape initialization
|-100

# State 0: jump dependent on the sign of the input number
0+ RM
000 M
011 M
022 M
033 M
044 M
055 M
066 M
077 M
088 M
099 M
0--Rm

# State M: move head to the end of the positive number
M00RM
M11RM
M22RM
M33RM
M44RM
M55RM
M66RM
M77RM
M88RM
M99RM
M  LI

# State m: move head to the end of the negative number
m00Rm
m11Rm
m22Rm
m33Rm
m44Rm
m55Rm
m66Rm
m77Rm
m88Rm
m99Rm
m  Li

# State I: increment the positive number, then exit
I01 $
I12 $
I23 $
I34 $
I45 $
I56 $
I67 $
I78 $
I89 $
I90LI
I 1 $

# State i: increment the negative number
i98 e
i87 e
i76 e
i65 e
i54 e
i43 e
i32 e
i21 e
i10Le
i09Li
i-- c

# State e: exit
e00 $
e11 $
e22 $
e33 $
e44 $
e55 $
e66 $
e77 $
e88 $
e99 $
e- RC

# State c: correct -0 edge case, then exit
c- Rc
c91 $

# State C: correct -1... edge case, then exit
C0-RC
C99 $
C 0LC
C-  $
