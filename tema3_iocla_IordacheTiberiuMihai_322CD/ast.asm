
section .data
    delim db " ", 0

section .bss
    root resd 1

section .text

extern check_atoi
extern print_tree_inorder
extern print_tree_preorder
extern evaluate_tree
extern malloc
extern strtok
extern strdup

global create_tree
global iocla_atoi
global recursiveCreateTree

iocla_atoi: 
    ; the string to be converted
    mov ebx, [esp + 4]
    ; used for iteration
    xor ecx, ecx 
    ; used for return value (the sum variable)
    xor eax, eax

start:
    ; check if we are at the end of the string
    cmp byte [ebx + ecx], 0x0
    je final

    ; check if the char is in range[0-9]
    cmp byte [ebx + ecx], 0x30
    jl increment

    cmp byte [ebx + ecx], 0x39
    ja increment

    ; save current data
    push ecx
    push eax
    
    xor eax, eax

    ; convert current char to integer
    mov al, byte [ebx + ecx]
    sub al, 0x30
    mov cl, al

    ; restore last integer
    pop eax

    ; multiply by 10
    mov edx, 10
    mul edx
    
    ; add the new integer
    add eax, ecx

    ;continue iteration
    pop ecx

increment:    
    inc ecx
    jmp start

final:
    ; check if the number is negative
    cmp byte[ebx], 0x2d
    jne finish

    mov edx, -1
    mul edx

finish:
    ret

recursiveCreateTree:
    ; save the previous data
    push ecx
    
    ; first arg the node
    mov eax, [esp + 8]
    ; second arg the key
    mov esi, [esp + 12]

    ; check if we still got keys to add to the tree
    cmp esi, 0x0
    jne compare

    mov dword [eax], 0x0

    jmp final_rec

compare:
    ; check if the key is an operator(*, +, -, /)
    cmp byte [esi], 0x2a
    je add_operator

    cmp byte [esi], 0x2b
    je add_operator

    cmp byte [esi], 0x2d
    je add_operator

    cmp byte [esi], 0x2f
    je add_operator

add_operand:
    ; first save the node
    push eax

    ; compute a copy of the key
    push esi
    call strdup
    add esp, 4

    mov edx, eax

    ; restore the node
    pop eax

    ; add the key to the node 
    mov [eax], edx

    push eax

    ; get the next key
    push delim
    push 0x0
    call strtok
    add esp, 8

    ; the new key
    mov esi, eax

    pop eax

    jmp final_rec

add_operator:
    ; guard for the case where we get a negative number to pass
    ; the operator check (first char is also "-")
    cmp byte [esi + 1], 0x0
    jne add_operand

    push eax
    
    ; compute a copy of the key
    push esi
    call strdup
    add esp, 4

    mov edx, eax

    pop eax

    ; add the key to the node 
    mov [eax], edx

    push eax

    ; get the next key
    push delim
    push 0x0
    call strtok
    add esp, 8 

    ; save the new key
    mov esi, eax

    pop eax

    ; check if we still have keys to add
    cmp esi, 0x0
    je final_rec

next_key:
    push eax

    ; allocate space for the left node
    push 4
    call malloc
    add esp, 4

    mov ebx, eax

    pop eax

    ; add the allocated node to current_node->left
    mov [eax + 4], ebx  

    push eax

    ; recursive call on current_node->left
    push esi
    push dword [eax + 4]
    call recursiveCreateTree
    add esp, 8

    mov ebx, eax

    pop eax

    ; save the recursive result to current_node->left
    mov dword [eax + 4], ebx

    push eax

    ; allocate space for the right node
    push 4
    call malloc
    add esp, 4

    mov ebx, eax
    
    pop eax

    ; add the allocated node to current_node->right
    mov [eax + 8], ebx

    push eax

    ; recursive call on current_node->right
    push esi
    push dword [eax + 8]
    call recursiveCreateTree
    add esp, 8

    mov ebx, eax

    pop eax

    ; save the recursive result to current_node->right
    mov dword [eax + 8], ebx

final_rec:
    ; restore ecx(modified by strtok and strdup)
    pop ecx

    ret

create_tree:
    enter 0, 0
    xor eax, eax

    ; save all the previous data
    pushad

    ; the string used for ast
    lea eax, [ebp + 8]

    ; compute a copy 
    push dword [eax]
    call strdup
    add esp, 4

    mov esi, eax

    ; compute the first char
    push delim
    push esi
    call strtok
    add esp, 8

    mov esi, eax

    ; allocate space for the root node
    push 4 
    call malloc 
    add esp, 4

    ; start creating the tree
    push esi
    push eax
    call recursiveCreateTree
    add esp, 8
    
    ; restore the data
    pop esi
    pop edi
    pop edx
    pop ecx
    pop ebx

    leave
    ret
