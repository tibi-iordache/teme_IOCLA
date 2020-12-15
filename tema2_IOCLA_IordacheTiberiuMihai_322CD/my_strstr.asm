%include "io.mac"

section .text
    global my_strstr
    extern printf

my_strstr:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len
    ;; DO NOT MODIFY
    
    push ecx                    ; save the haystack_len
    push edx                    ; save the needle_len

    xor ecx, ecx                ; clear ecx for interation

get_the_char:
    mov al, byte [esi + ecx]    ; get the current char from haystack

    cmp al, byte [ebx]          ; compare with the first char from needle
    je first_char_found         ; if equal, we found the first char 

    inc ecx                     ; if not, continue iteration

    cmp ecx, [esp + 4]         ; until we get to end of haystack
    jl get_the_char

    jmp finish_not_found        ; if the needle was not found, end the program

first_char_found:
    xor edx, edx                ; clear edx for iteration    
    mov [edi], ecx              ; save in edi the first index 

continue_comparing:
    inc ecx                     ; inc both haystack and needle index
    inc edx        

    mov al, byte [esi + ecx]    ; get the next char from the haystack

    cmp al, byte [ebx + edx]    ; compare it with the next char from needle
    je continue_comparing       ; continue as long as they are equal

    ; they stopped being equal
    cmp edx, [esp]              ; check if we found all the needle chars
    je end

    jmp get_the_char            ; else check the rest of the string

finish_not_found:
    mov ecx, [esp + 4]          ; needle was not found, return haystack len + 1

    inc ecx

    mov [edi], ecx              ; save it in edi

end:
    pop eax                     ; remove the saved values from the stack
    pop eax

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
