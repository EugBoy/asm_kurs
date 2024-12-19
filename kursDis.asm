.model small
.386
.stack 100h
.data
    filename            db  "KURSFROM.COM"
    filedesc            dw  ?
    fileout             db  "OUT.TXT"
    fileoutdesc         dw  ?
    buffer              db  ?
    bytesRead           dw  ?        
    commandline         db  30 dup(?)
    lods_com            db  'lodsb', 'lodsw', 'lodsd'
    jcc_singl_op        db  'JO  ', 'JNO ', 'JC  ', 'JNS ', 'JE  ', 'JNE ', 'JBE ', 'JA  ', 'JS  ', 'JNS ', 'JP  ', 'JNP ', 'JL  ', 'JNL ', 'JNG ', 'JNLE', 'JCXZ'
    jcc_addr_buffer     db  2 dup(?)
    jcc_single_op_str    db  ' +000'
    jcc_is_single_op    db  0
    cnl                 db  0Dh, 0Ah, 0Dh, 0Ah 
.code
Start:
    mov     ax, @data
    mov     ds, ax

open_file:
    mov     ah, 03Dh
    mov     al, 0         
    mov     dx, offset filename
    int     21h
    mov     [filedesc], ax
    
    mov     ah, 03Ch
    mov     al, 0         
    mov     dx, offset fileout
    int     21h
    mov     [fileoutdesc], ax    
read_file_start:
    mov     ah, 03Fh 
    mov     bx, [filedesc]
    mov     dx, offset buffer
    mov     cx, 1   
    int     21h         
    mov     [bytesRead], ax
    cmp     ax, 0
    je      finish
    xor     ax, ax  
    mov     al, [buffer]
    cmp     ax, 0ACh    ;lodsb
    je      lodsb_comand
    cmp     ax, 0ADh    ;lodsw
    je      lodsw_comand
    cmp ax, 066h    ;spread r for btr / lodsd
    je  big_data
    cmp ax, 090h
    je read_file_start
    cmp ax, 0Fh
    jne not_byn_op
    mov jcc_is_single_op, 1
    jmp read_file_start
not_byn_op:
check_jcc:
    cmp ax, 0E3h
    jne continue_check_jcc
    mov dx, 64
    jmp jcc_comand
continue_check_jcc:
    cmp ax, 70h    
    jl check_btr
    cmp ax, 08Fh
    ja check_btr
    cmp ax, 080h
    jl continue_with_correct_addr
    sub ax, 10h 
continue_with_correct_addr:
    mov dx, ax
    sub dx, 070h
    jmp jcc_comand
check_btr:
    jmp read_file_start
big_data:
    mov     ah, 03Fh 
    mov     bx, [filedesc]
    mov     dx, offset buffer
    mov     cx, 1   
    int     21h         
    mov     [bytesRead], ax
    cmp ax, 0
    je finish
    mov     al, [buffer]
    cmp ax, 0ADh
    je lodsd_comand
    jmp read_file_start
lodsb_comand:
    mov ah, 040h
    mov bx, [fileoutdesc]
    mov cx, 5
    mov dx, offset lods_com
    int 21h
    mov ah, 040h
    mov cx, 4
    mov dx, offset cnl
    int 21h
    jmp read_file_start
lodsw_comand:
    mov ah, 040h
    mov bx, [fileoutdesc]
    mov cx, 5
    mov dx, offset lods_com
    add dx, 5
    int 21h
    mov ah, 040h
    mov cx, 4
    mov dx, offset cnl
    int 21h
    jmp read_file_start
lodsd_comand:
    mov ah, 040h
    mov bx, [fileoutdesc]
    mov cx, 5
    mov dx, offset lods_com
    add dx, 10
    int 21h
    mov ah, 040h
    mov cx, 4
    mov dx, offset cnl
    int 21h
    jmp read_file_start
jcc_comand:
    mov ax, dx
    imul ax, 4h
    mov dx, ax
    add dx, offset lods_com
    mov bp, ax
    
    cmp jcc_is_single_op, 1
    je  jcc_read_word
    mov     ah, 03Fh 
    mov     bx, [filedesc]
    mov     dx, offset buffer
    mov     cx, 1   
    int     21h
    cmp     ax, 0
    je finish
    mov al, [buffer]
    cmp al, 0
    jns pos_op
    inc al
    neg al
    inc al
    mov [jcc_single_op_str + 1], '-'
pos_op:    
    xor ah, ah
    aam
    add al, 30h
    mov [jcc_single_op_str + 4], al
    mov al, ah
    aam
    add al, 30h
    add ah, 30h
    mov [jcc_single_op_str + 3], al
    mov [jcc_single_op_str + 2], ah
    
    mov ah, 040h
    mov bx, [fileoutdesc]
    mov cx, 4
    mov dx, offset jcc_singl_op
    add dx, bp
    int 21h 
    
    mov ah, 040h
    mov bx, [fileoutdesc]
    mov cx, 5
    mov dx, offset jcc_single_op_str
    int 21h 
    
    mov ah, 040h
    mov cx, 4
    mov dx, offset cnl
    int 21h
    
    mov [jcc_single_op_str + 1], '+'
    mov jcc_is_single_op, 0
    
    jmp read_file_start
jcc_read_word:
finish:
    mov ah, 4Ch
    int     21h
end Start