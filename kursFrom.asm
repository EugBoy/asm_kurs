.model tiny
.386
.code
org 100h   
start:
lodsb
lodsw
lodsd
JE       longJump
JNLE     longJump
JGE      longJump
JL       longJump
JLE      longJump
JNB      longJump
JNE      longJump
JNO      longJump
JNP      longJump
JNS      longJump
JO       longJump
JPE      longJump
JS       longJump
JB       longJump
JA       longJump
JNB      longJump
JBE      longJump
db 0Fh, 84h, 5h, 35h
db 0Fh, 8Fh, 6h, 35h
db 0Fh, 8Dh, 7h, 35h
db 0Fh, 8Ch, 8h, 35h
db 0Fh, 8Eh, 9h, 35h
db 0Fh, 83h, 0Ah, 35h
db 0Fh, 85h, 0Bh, 35h
db 0Fh, 81h, 0Eh, 35h
db 0Fh, 8Bh, 0Fh, 35h
db 0Fh, 89h, 10h, 35h
db 0Fh, 80h, 11h, 35h
db 0Fh, 8Ah, 12h, 35h
db 0Fh, 88h, 13h, 35h
db 0Fh, 82h, 00h
db 80h
db 0Fh, 87h, 03h
db 0E9h
db 0Fh, 83h, 0FCh
db 19h
db 0Fh, 86h, 7Fh
db 0FFh
;////////////////////////////// short jcc 
JAE      short shortJump
JB       short shortJump
JBE      short shortJump
JCXZ     short shortJump
JE       short shortJump
JG       short shortJump
JGE      short shortJump
JL       short shortJump
JLE      short shortJump
JNE      short shortJump
JNO      short shortJump
JNP      short shortJump
JNS      short shortJump
JO       short shortJump
JP       short shortJump
JS       short shortJump
JA       short shortJump
db 73h,12h ;JAE or JNB or JNC
db 72h,34h ;JB or JC or JNAE
db 76h,56h ;JBE or JNA
db 0E3h,78h ;JCXZ or JECXZ
db 74h,9Ah ;JE or JZ
db 7Fh,0BCh ;JG or JNLE
db 7Dh,0DEh ;JGE or JNL
db 7Ch,0Fh ;JL or JNGE
db 7Eh,00h ;JLE or JNG
db 75h,00h ;JNE or JNZ
db 71h,00h ;JNO
db 7Bh,00h ;JNP or JPO
db 79h,00h ;JNS
db 70h,00h ;JO
db 7Ah,00h ;JP or JPE
db 78h,00h ;JS
db 77h,00h ;JA or JNBE 
shortJump:
lodsb
lodsw
lodsd
;////////////////////////////// long jcc 

;////////////////////////////// btr m32,r32
;////////////////////////////// btr m16,imm6
;////////////////////////////// btr m32,imm6
longJump:
lodsb
lodsw
lodsd
end start