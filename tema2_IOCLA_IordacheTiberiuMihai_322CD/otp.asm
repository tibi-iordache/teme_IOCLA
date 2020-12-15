%include "io.mac"

section .text
    global otp
    extern printf

otp:
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

xor_two_chars:
    mov al, byte[esi + ebx]     ; copy the plaintext[i] text in al
    
    xor al, byte[edi + ebx]     ; xor plaintext[i] with key[i]
    
    mov byte [edx + ebx], al    ; move the result to ciphertext

    inc ebx                     ; increment

    cmp ebx, ecx                ; test if we are at the end of the strings
    jl xor_two_chars            ; continue the iteration 

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY