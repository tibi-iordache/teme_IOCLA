%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY
    
    xor ebx, ebx                ; used for incrementation

    cmp edi, 0x1A               ; check if key > 25
    jl get_the_char             ; if not, start the conversion

calculate_new_key:
    sub edi, 0x1A               ; sub 26 from the key
                                
    cmp edi, 0x1A               ; check again and repeat until key <= 25
    jge calculate_new_key

get_the_char:
    mov al, byte [esi + ebx]    ; copy the plaintext[i] text in al 

    cmp al, 0x41                ; compare with "A"
    jl save_the_char            ; jump to next char if less

    cmp al, 0x5A                ; compare with "Z"
    jle big_letter              ; the char is >= "A" && <= "Z"

    cmp al, 0x61                ; compare with "a"
    jl save_the_char            ; jump to next char if less

    cmp al, 0x7A                ; compare with "z"
    jg save_the_char            ; > "z" the char is not a letter

small_letter:
    add eax, edi                ; add the key to letter     

    cmp eax, 0x7A               ; compare with "z"
    jle save_the_char           ; if it's lower, the conversion was ok

    sub eax, 0x1A               ; else we got over "z", so we substract 26
                                ; to keep the circular motion
    
    jmp save_the_char           

big_letter:
    add eax, edi                ; add the key to letter

    cmp eax, 0x5A               ; compare with "Z"
    jle save_the_char           ; if it is lower, the conversion was ok

    sub eax, 0x1A               ; else, we substract 26        
    
save_the_char:
    mov byte [edx + ebx], al    ; save the letter in the edx(ciphertext)             
   
    inc ebx                     ; continue iteration
    
    cmp ebx, ecx                ; test if we are at the end of the string
    jl get_the_char             ; if not, go to next char

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY