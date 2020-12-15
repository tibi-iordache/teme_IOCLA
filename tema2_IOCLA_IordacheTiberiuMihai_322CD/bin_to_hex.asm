%include "io.mac"

section .text
    global bin_to_hex
    extern printf

bin_to_hex:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length
    ;; DO NOT MODIFY

    mov bl, 0x4                 ; the size of a nibble
    mov al, cl                  ; copy the size of the bin_sequence
    div bl                      ; divide them

    mov ebx, eax                ; make a copy of eax
    shr ebx, 8                  ; shift eax by 8 to get ah

    push ebx                    ; save ah in stack so we can use it later
    
    mov bl, al                  ; move al into eax, by using ebx              
    mov eax, ebx                ; so we got the numbers of nibbles 

    cmp byte [esp], 0x0         ; check if we got any rest in ah
    jne base_starts_from_1      

    mov byte [edx + eax], 0xA          ; add enter
    mov byte [edx + eax + 1], 0x0       ; add null terminator

    jmp start

base_starts_from_1:
    ; because of the rest from ah, we need to leave 1 position for those bits
    mov byte [edx + eax + 1], 0xA       ; add enter
    mov byte [edx + eax + 2], 0x0       ; add null terminator

start:
    xor ebx, ebx                ; bits counter

    xor eax, eax                ; used to compute values
    
reverse_iteration:              
    cmp byte [esi + ecx - 1], 0x31 ; check if we got a bit equal to 1
    je add_one

iterate:
    inc ebx                     ; inc bits counter

    dec ecx                     ; continue iteration

    cmp ebx, 0x4                ; check if we got a nibble to convert
    je form_nibble

    cmp ecx, 0x1                ; stop when ecx becomes 0
    jge reverse_iteration

    jmp form_nibble             ; jump in case we get < 4 bits (the rest in ah)

add_one:    
    push ebx                    ; save the current bits counter
    push ecx                    ; save the curent index

    mov cl, 1                   ; start forming the bit to be added

    cmp ebx, 0x0                ; check if we need to shift
    je shift_done

shift_the_bit_to_be_added:
    shl cl, 1                   ; shift the bit 
    
    dec ebx                     ; repeat for ebx times

    cmp ebx, 0x0
    jg shift_the_bit_to_be_added

shift_done:
    ; now we add the shifted bit to the current al
    not al                      ; first we negate al

    xor al, cl                  ; xor with the shifted bit
    
    not al                      ; negate it again to get the result of the sum

    pop ecx                     ; retrive saved values
    pop ebx
    
    jmp iterate                 ; continue iteration

form_nibble:
    ; guard in case we got any rest in ah
    cmp bl, 0x4                 ; check how many bits we have in counter
    jl add_to_first_positon

    push eax                    ; save the al to be added in edx

    mov al, cl                  ; copy the current position
    div bl                      ; we divide it by 4(the size of the nibble)
    
    mov bl, al                  ; save the result of the division in bl

    pop eax                     ; get back the al value
    
    cmp byte [esp], 0x0         ; we check if we got any rest in ah
    je skip_incrementing

    inc ebx                     ; if we got, we increment by one the index
                                ; to add to the correct position

skip_incrementing:
    cmp al, 0x9                 ; check if we got a  number
    jle number_to_ascii

    ; else we got a letter
    add al, 0x37                ; we convert it to ascii      
    jmp save_in_result

number_to_ascii:
    add al, 0x30                ; we convert the number to ascii

save_in_result:
    mov byte [edx + ebx], al    ; add the letter/number to the result string

    jmp next_nibble             ; continue to the next nibble

add_to_first_positon:
    xor ebx, ebx                ; we set the value of index to 0

    jmp skip_incrementing       ; and go to convertion part

next_nibble:   
    cmp cl, 0x0                 ; check if we got at the end of the string
    je finish

    xor eax, eax                ; if not, we reset the registers
    xor ebx, ebx

    jmp reverse_iteration       ; and continue iteration

finish:
    pop ebx                     ; pop the ah from the stack

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY