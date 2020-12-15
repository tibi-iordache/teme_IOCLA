%include "io.mac"

section .text
    global vigenere
    extern printf

vigenere:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len
    ;; DO NOT MODIFY
    
    push ecx                    ; save ecx value
    push ebx                    ; save ebx value

    xor ecx, ecx                ; used for plaintext iteration
    xor ebx, ebx                ; used for key iteration

get_the_char:
    mov al, byte [esi + ecx]    ; copy the plaintext[i] text in al 

    cmp al, 0x41                ; compare with "A"
    jl save_the_char            ; jump to next char if less

    cmp al, 0x5A                ; compare with "Z"
    jle big_letter              ; the char is >= "A" && <= "Z"

    cmp al, 0x61                ; compare with "a"
    jl save_the_char            ; jump to next char if less

    cmp al, 0x7A                ; compare with "z"
    jg save_the_char            ; > "z" the char is not a letter

small_letter:
    cmp ebx, [esp]              ; check if we are at the end of the key
    jl circular_move_small_letter

    xor ebx, ebx                ; restart the key

circular_move_small_letter: 
    mov al, byte [edi + ebx]    ; move the key[i]

    cmp eax, 0x41               ; check if key was already converted
    jl next1

    sub eax, 0x41               ; if not convert the key

next1:  
    add al, byte [esi + ecx]    ; add the plain[i] to the key[i] converted

    inc ebx                     ; increment key index

    cmp eax, 0x7A               ; compare with "z"
    jle save_the_char           ; if it's lower, the conversion was ok

    sub eax, 0x1A               ; else we got over "z", so we substract 26
                                ; to keep the circular motion
    
    jmp save_the_char           

big_letter:
    cmp ebx, [esp]              ; check if we are at the end of the key
    jl circular_move_big_letter

    xor ebx, ebx                ; restart the key

circular_move_big_letter:
    mov al, byte [edi + ebx]    ; copy key[i] in al
    
    cmp eax, 0x41               ; check if it was already converted
    jl next2

    sub eax, 0x41               ; convert from alphabeticat to index

next2:    
    add al, byte [esi + ecx]    ; add plain[i] to key[i]
               
    inc ebx                     ; increment key index

    cmp eax, 0x5A               ; compare with "Z"
    jle save_the_char           ; if it is lower, the conversion was ok

    sub eax, 0x1A               ; else, we substract 26        

save_the_char:
    mov byte [edx + ecx], al    ; save the letter in the edx(ciphertext)             
    
    inc ecx                     ; continue iteration
    
    cmp ecx, [esp + 4]          ; test if we are at the end of the string
    jl get_the_char             ; if not, go to next char

    ; else finish the program

    pop eax                     ; remove the saved length 
    pop eax

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY